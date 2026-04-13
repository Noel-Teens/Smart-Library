import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/core/utils/error_handler.dart';
import 'package:library_management_app/core/widgets/error_state_widget.dart';
import 'package:library_management_app/features/admin/presentation/providers/admin_provider.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';

/// User management screen — search, view, change role, freeze/unfreeze.
class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState
    extends ConsumerState<UserManagementScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: Column(
        children: [
          // ── Search Bar ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search by name or email…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.neutral50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ── User List ──
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(usersNotifierProvider);
              },
              child: usersAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => ErrorStateWidget(
                  error: e,
                  onRetry: () => ref.invalidate(usersNotifierProvider),
                ),
                data: (users) {
                  final filtered = _searchQuery.isEmpty
                      ? users
                      : users
                          .where((u) =>
                              u.name
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) ||
                              u.email
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()))
                          .toList();

                  if (filtered.isEmpty) {
                    return ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.4,
                          child: const Center(
                            child: Text('No users found',
                                style: TextStyle(color: AppColors.textTertiary)),
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final user = filtered[index];
                      return _UserTile(
                        user: user,
                        onRoleChanged: (role) async {
                          try {
                            await ref
                                .read(usersNotifierProvider.notifier)
                                .updateRole(user.id, role);
                            if (context.mounted) {
                              showSuccessSnackBar(
                                  context, 'Role updated to ${role.label}');
                            }
                          } catch (e) {
                            if (context.mounted) showErrorSnackBar(context, e);
                          }
                        },
                        onFreezeToggled: () async {
                          try {
                            await ref
                                .read(usersNotifierProvider.notifier)
                                .toggleFreeze(user.id, !user.isFrozen);
                            if (context.mounted) {
                              showSuccessSnackBar(
                                  context,
                                  user.isFrozen
                                      ? 'Account unfrozen'
                                      : 'Account frozen');
                            }
                          } catch (e) {
                            if (context.mounted) showErrorSnackBar(context, e);
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateUserDialog(context),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text(
          'Create User',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showCreateUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _CreateUserDialog(
        onCreated: (email, password, name, role) async {
          try {
            await ref.read(usersNotifierProvider.notifier).createUser(
                  email: email,
                  password: password,
                  name: name,
                  role: role,
                );
            if (context.mounted) {
              showSuccessSnackBar(context, '$name created as ${role.label}');
            }
          } catch (e) {
            if (context.mounted) showErrorSnackBar(context, e);
          }
        },
      ),
    );
  }
}

/// Dialog for creating a new user account.
class _CreateUserDialog extends StatefulWidget {
  const _CreateUserDialog({required this.onCreated});

  final Future<void> Function(
    String email,
    String password,
    String name,
    UserRole role,
  ) onCreated;

  @override
  State<_CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<_CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  UserRole _selectedRole = UserRole.student;
  bool _isCreating = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isCreating = true);

    await widget.onCreated(
      _emailCtrl.text.replaceAll(RegExp(r'\s+'), ''),
      _passwordCtrl.text.trim(),
      _nameCtrl.text.trim(),
      _selectedRole,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.person_add_rounded, size: 22, color: AppColors.primary600),
          SizedBox(width: 10),
          Text(
            'Create New User',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline, size: 20),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(v.trim()) || v.trim().endsWith('@example.com')) {
                    return 'Enter a valid real email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Password is required';
                  }
                  if (v.trim().length < 6) {
                    return 'Minimum 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<UserRole>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  prefixIcon: Icon(Icons.badge_outlined, size: 20),
                ),
                items: UserRole.values.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role.label),
                  );
                }).toList(),
                onChanged: (role) {
                  if (role != null) setState(() => _selectedRole = role);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCreating ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _isCreating ? null : _submit,
          icon: _isCreating
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check_rounded, size: 18),
          label: Text(_isCreating ? 'Creating…' : 'Create'),
        ),
      ],
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.user,
    required this.onRoleChanged,
    required this.onFreezeToggled,
  });

  final UserEntity user;
  final ValueChanged<UserRole> onRoleChanged;
  final VoidCallback onFreezeToggled;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary100,
                  child: Text(
                    user.name.isNotEmpty
                        ? user.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user.name,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (user.isFrozen) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.error100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'FROZEN',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.error700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // ── Role selector ──
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.neutral50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<UserRole>(
                        value: user.role,
                        isExpanded: true,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                        items: UserRole.values.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role.label),
                          );
                        }).toList(),
                        onChanged: (role) {
                          if (role != null && role != user.role) {
                            onRoleChanged(role);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // ── Freeze toggle ──
                OutlinedButton.icon(
                  onPressed: onFreezeToggled,
                  icon: Icon(
                    user.isFrozen
                        ? Icons.lock_open_rounded
                        : Icons.lock_rounded,
                    size: 16,
                    color: user.isFrozen
                        ? AppColors.success600
                        : AppColors.error500,
                  ),
                  label: Text(
                    user.isFrozen ? 'Unfreeze' : 'Freeze',
                    style: TextStyle(
                      fontSize: 12,
                      color: user.isFrozen
                          ? AppColors.success600
                          : AppColors.error500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: user.isFrozen
                          ? AppColors.success100
                          : AppColors.error100,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
