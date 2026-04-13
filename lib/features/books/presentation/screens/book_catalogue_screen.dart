import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/core/widgets/error_state_widget.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_management_app/features/books/presentation/providers/books_provider.dart';
import 'package:library_management_app/features/books/presentation/screens/book_form_screen.dart';
import 'package:library_management_app/features/books/presentation/widgets/book_card.dart';

/// The main book catalogue screen showing a searchable grid of books.
class BookCatalogueScreen extends ConsumerStatefulWidget {
  const BookCatalogueScreen({super.key});

  @override
  ConsumerState<BookCatalogueScreen> createState() =>
      _BookCatalogueScreenState();
}

class _BookCatalogueScreenState extends ConsumerState<BookCatalogueScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(filteredBooksProvider);
    final user = ref.watch(authNotifierProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.white,
                  fontSize: 16,
                ),
                cursorColor: AppColors.accent200,
                decoration: InputDecoration(
                  hintText: 'Search by title, author, genre…',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.white.withValues(alpha: 0.5),
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                ),
                onChanged: (value) {
                  ref.read(bookSearchQueryProvider.notifier).state = value;
                },
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Book Catalogue'),
                  if (user != null)
                    Text(
                      'Welcome, ${user.name.split(' ').first}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  ref.read(bookSearchQueryProvider.notifier).state = '';
                }
              });
            },
          ),
        ],
      ),
      floatingActionButton: (user?.role == UserRole.librarian ||
              user?.role == UserRole.admin)
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const BookFormScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Add Book',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(filteredBooksProvider);
        },
        child: booksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorStateWidget(
            error: e,
            onRetry: () => ref.invalidate(filteredBooksProvider),
          ),
          data: (books) {
            if (books.isEmpty) {
              return ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.neutral300,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No books found',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Try a different search term',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return BookCard(
                    book: book,
                    onTap: () {
                      final location = GoRouterState.of(context).uri.toString();
                      String basePath;
                      if (location.startsWith('/librarian')) {
                        basePath = '/librarian/books';
                      } else if (location.startsWith('/admin')) {
                        basePath = '/admin/books';
                      } else if (location.startsWith('/staff')) {
                        basePath = '/staff/books';
                      } else {
                        basePath = '/student/books';
                      }
                      context.push('$basePath/${book.id}');
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
