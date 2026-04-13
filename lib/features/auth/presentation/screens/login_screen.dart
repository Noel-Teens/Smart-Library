import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/core/constants/app_constants.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/core/utils/error_handler.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_management_app/features/auth/presentation/widgets/google_sign_in_button.dart';

/// The login / landing screen.
///
/// Features a branded gradient background, app title, email/password
/// form with sign-in and registration modes, and Google Sign-In button.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isRegisterMode = false;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  /// Sign in via email/password.
  Future<void> _handleLogin() async {
    if (_emailCtrl.text.trim().isEmpty ||
        _passwordCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: AppColors.error500,
        ),
      );
      return;
    }
    final cleanedEmail = _emailCtrl.text.replaceAll(RegExp(r'\s+'), '');
    
    // Explicit format validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(cleanedEmail) || cleanedEmail.endsWith('@example.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email account. Test accounts are not permitted.'),
          backgroundColor: AppColors.error500,
        ),
      );
      return;
    }

    await ref.read(authNotifierProvider.notifier).signInWithPassword(
          email: cleanedEmail,
          password: _passwordCtrl.text.trim(),
    );
  }

  /// Register a new account.
  Future<void> _handleRegister() async {
    if (_nameCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _passwordCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: AppColors.error500,
        ),
      );
      return;
    }
    if (_passwordCtrl.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
          backgroundColor: AppColors.error500,
        ),
      );
      return;
    }
    final cleanedEmail = _emailCtrl.text.replaceAll(RegExp(r'\s+'), '');

    // Explicit format validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(cleanedEmail) || cleanedEmail.endsWith('@example.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email account. Test accounts are not permitted.'),
          backgroundColor: AppColors.error500,
        ),
      );
      return;
    }

    await ref.read(authNotifierProvider.notifier).signUp(
          email: cleanedEmail,
          password: _passwordCtrl.text.trim(),
          name: _nameCtrl.text.trim(),
        );
  }

  /// Sign in via Google OAuth.
  Future<void> _handleGoogleSignIn() async {
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AsyncLoading;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary900,
              AppColors.primary700,
              AppColors.primary600,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height -
                      MediaQuery.paddingOf(context).top -
                      MediaQuery.paddingOf(context).bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 36),

                    // ── App Icon ──
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.local_library_rounded,
                        size: 46,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── App Name ──
                    const Text(
                      AppConstants.appName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // ── Tagline ──
                    Text(
                      AppConstants.appTagline,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.accent200,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // ── Name Field (Register mode only) ──
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _isRegisterMode
                          ? Column(
                              children: [
                                _buildTextField(
                                  controller: _nameCtrl,
                                  hintText: 'Full name',
                                  prefixIcon: Icons.person_outline,
                                ),
                                const SizedBox(height: 14),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    // ── Email Field ──
                    _buildTextField(
                      controller: _emailCtrl,
                      hintText: 'Email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),

                    // ── Password Field ──
                    _buildTextField(
                      controller: _passwordCtrl,
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscure: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.white.withValues(alpha: 0.6),
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Login / Register Button ──
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : (_isRegisterMode
                                ? _handleRegister
                                : _handleLogin),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent500,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _isRegisterMode
                                    ? 'Create Account'
                                    : 'Sign In',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Toggle Login / Register ──
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isRegisterMode = !_isRegisterMode;
                        });
                      },
                      child: Text(
                        _isRegisterMode
                            ? 'Already have an account? Sign In'
                            : "Don't have an account? Create one",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: AppColors.accent200,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Divider ──
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.white.withValues(alpha: 0.2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Google Sign In Button ──
                    GoogleSignInButton(
                      onPressed: _handleGoogleSignIn,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 16),

                    // ── Error Message ──
                    if (authState is AsyncError)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error500.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.error100,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                AppError.friendlyMessage(authState.error!),
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: AppColors.error100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 36),

                    // ── Version Footer ──
                    Text(
                      AppConstants.appVersion,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.white.withValues(alpha: 0.35),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        color: AppColors.white,
      ),
      cursorColor: AppColors.accent200,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: AppColors.white.withValues(alpha: 0.45),
        ),
        prefixIcon: Icon(
          prefixIcon,
          size: 20,
          color: AppColors.white.withValues(alpha: 0.6),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.white.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.white.withValues(alpha: 0.15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.accent500,
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
