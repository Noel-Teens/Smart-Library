import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/core/utils/error_handler.dart';
import 'package:library_management_app/core/widgets/error_state_widget.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_management_app/features/books/domain/entities/book_entity.dart';
import 'package:library_management_app/features/books/presentation/providers/books_provider.dart';
import 'package:library_management_app/features/books/presentation/screens/book_form_screen.dart';
import 'package:library_management_app/features/books/presentation/widgets/availability_badge.dart';
import 'package:library_management_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:library_management_app/features/transactions/presentation/providers/transactions_provider.dart';

/// Full book detail screen with cover, metadata, and request button.
class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({super.key, required this.bookId});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(bookByIdProvider(bookId));

    return Scaffold(
      body: bookAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorStateWidget(
          error: e,
          onRetry: () => ref.invalidate(bookByIdProvider(bookId)),
        ),
        data: (book) {
          if (book == null) {
            return const Center(child: Text('Book not found'));
          }
          return _BookDetailBody(book: book);
        },
      ),
    );
  }
}

class _BookDetailBody extends ConsumerWidget {
  const _BookDetailBody({required this.book});

  final BookEntity book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        // ── Collapsing Cover ──
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _gradientForGenre(book.genre),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),
                  Text(
                    book.title.isNotEmpty ? book.title[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 72,
                      fontWeight: FontWeight.w700,
                      color: Colors.white38,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      book.genre,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Content ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  book.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),

                // Author
                Text(
                  'by ${book.author}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),

                // Badges Row
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    AvailabilityBadge(
                      available: book.availableCopies,
                      total: book.totalCopies,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.neutral100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'ISBN: ${book.isbn}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description
                if (book.description != null && book.description!.isNotEmpty) ...[
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.description!,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Copies info card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _InfoTile(
                          icon: Icons.library_books_outlined,
                          label: 'Total',
                          value: '${book.totalCopies}',
                        ),
                        const SizedBox(width: 24),
                        _InfoTile(
                          icon: Icons.check_circle_outline,
                          label: 'Available',
                          value: '${book.availableCopies}',
                          color: book.isAvailable
                              ? AppColors.success600
                              : AppColors.error500,
                        ),
                        const SizedBox(width: 24),
                        _InfoTile(
                          icon: Icons.bookmark_outline,
                          label: 'Borrowed',
                          value:
                              '${book.totalCopies - book.availableCopies}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Action Buttons (role-aware) ──
                Builder(builder: (context) {
                  final user = ref.watch(authNotifierProvider).valueOrNull;
                  final role = user?.role;
                  final isStudentRole = role == UserRole.student;
                  final canManage = role == UserRole.librarian ||
                      role == UserRole.admin;

                  return Column(
                    children: [
                      // Student: Request button
                      if (isStudentRole)
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: (book.isAvailable && user?.isFrozen != true)
                                ? () => _onRequest(context, ref)
                                : null,
                            icon: Icon(
                              user?.isFrozen == true
                                  ? Icons.do_not_disturb_on_total_silence
                                  : (book.isAvailable
                                      ? Icons.menu_book_rounded
                                      : Icons.block),
                            ),
                            label: Text(
                              user?.isFrozen == true
                                  ? 'Account Frozen (Unpaid Dues)'
                                  : (book.isAvailable
                                      ? 'Request This Book'
                                      : 'Currently Unavailable'),
                            ),
                          ),
                        ),

                      // Librarian/Admin: Edit & Delete
                      if (canManage) ...[
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BookFormScreen(book: book),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_rounded),
                            label: const Text('Edit Book'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _onDelete(context, ref),
                            icon: const Icon(Icons.delete_rounded,
                                color: AppColors.error500),
                            label: const Text('Delete Book',
                                style: TextStyle(
                                    color: AppColors.error500)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: AppColors.error100),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                }),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onRequest(BuildContext context, WidgetRef ref) {
    final user = ref.read(authNotifierProvider).valueOrNull;
    if (user == null) return;

    final txns = ref.read(transactionsNotifierProvider).valueOrNull ?? [];
    final hasActiveTxn = txns.any((t) =>
        t.bookId == book.id &&
        (t.status == TransactionStatus.requested ||
         t.status == TransactionStatus.issued));

    if (hasActiveTxn) {
      showErrorSnackBar(context, 'You already have an active request or have borrowed this book.');
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request Book'),
        content: Text('Submit a borrow request for "${book.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref
                    .read(transactionsNotifierProvider.notifier)
                    .createRequest(
                      bookId: book.id,
                      bookTitle: book.title,
                      bookAuthor: book.author,
                    );
                if (context.mounted) {
                  showSuccessSnackBar(
                      context, 'Request submitted for "${book.title}"');
                }
              } catch (e) {
                if (context.mounted) showErrorSnackBar(context, e);
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _onDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Book'),
        content: Text(
            'Permanently remove "${book.title}" from the catalogue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error500,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await deleteBookAction(ref, book.id);
                if (context.mounted) {
                  showSuccessSnackBar(context, '"${book.title}" deleted');
                  context.pop();
                }
              } catch (e) {
                if (context.mounted) showErrorSnackBar(context, e);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<Color> _gradientForGenre(String genre) {
    switch (genre.toLowerCase()) {
      case 'fiction':
        return [const Color(0xFF4A6CF7), const Color(0xFF6366F1)];
      case 'dystopian':
        return [const Color(0xFF6B21A8), const Color(0xFF9333EA)];
      case 'romance':
        return [const Color(0xFFDB2777), const Color(0xFFF472B6)];
      case 'computer science':
        return [const Color(0xFF0891B2), const Color(0xFF22D3EE)];
      case 'science':
        return [const Color(0xFF059669), const Color(0xFF34D399)];
      case 'science fiction':
        return [const Color(0xFF7C3AED), const Color(0xFFA78BFA)];
      case 'history':
        return [const Color(0xFFB45309), const Color(0xFFFBBF24)];
      case 'self-help':
        return [const Color(0xFFEA580C), const Color(0xFFFB923C)];
      case 'psychology':
        return [const Color(0xFF0D9488), const Color(0xFF5EEAD4)];
      case 'philosophy':
        return [const Color(0xFF64748B), const Color(0xFF94A3B8)];
      case 'memoir':
        return [const Color(0xFFBE185D), const Color(0xFFFDA4AF)];
      default:
        return [AppColors.primary700, AppColors.primary500];
    }
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 22, color: color ?? AppColors.neutral500),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color ?? AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
