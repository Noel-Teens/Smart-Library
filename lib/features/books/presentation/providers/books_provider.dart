import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/features/books/data/datasources/supabase_books_datasource.dart';
import 'package:library_management_app/features/books/data/repositories/books_repository_impl.dart';
import 'package:library_management_app/features/books/domain/entities/book_entity.dart';
import 'package:library_management_app/features/books/domain/repositories/books_repository.dart';

// ──────────────────────────────────────────────
// Datasource & Repository Providers
// ──────────────────────────────────────────────
final _booksDsProvider = Provider<SupabaseBooksDataSource>((ref) {
  return SupabaseBooksDataSource();
});

final booksRepositoryProvider = Provider<BooksRepository>((ref) {
  return BooksRepositoryImpl(ref.watch(_booksDsProvider));
});

// ──────────────────────────────────────────────
// Book List Providers
// ──────────────────────────────────────────────

/// Current search query.
final bookSearchQueryProvider = StateProvider<String>((ref) => '');

/// Trigger counter — incremented after add/update/delete to force refresh.
final _booksRefreshProvider = StateProvider<int>((ref) => 0);

/// All books (or filtered by search query).
final filteredBooksProvider = FutureProvider<List<BookEntity>>((ref) async {
  ref.watch(_booksRefreshProvider);
  final query = ref.watch(bookSearchQueryProvider);
  final repo = ref.watch(booksRepositoryProvider);

  if (query.isEmpty) {
    return repo.getAllBooks();
  }
  return repo.searchBooks(query);
});

/// A single book by ID.
final bookByIdProvider =
    FutureProvider.family<BookEntity?, String>((ref, id) async {
  ref.watch(_booksRefreshProvider);
  final repo = ref.watch(booksRepositoryProvider);
  return repo.getBookById(id);
});

// ──────────────────────────────────────────────
// Book Request
// ──────────────────────────────────────────────

/// Provider to handle a book borrow request.
final requestBookProvider =
    FutureProvider.family<bool, ({String bookId, String userId})>(
        (ref, params) async {
  final repo = ref.watch(booksRepositoryProvider);
  return repo.requestBook(params.bookId, params.userId);
});

// ──────────────────────────────────────────────
// Book Mutations (CRUD)
// ──────────────────────────────────────────────

/// Add a new book and refresh the list.
Future<void> addBookAction(WidgetRef ref, BookEntity book) async {
  final repo = ref.read(booksRepositoryProvider);
  await repo.addBook(book);
  ref.read(_booksRefreshProvider.notifier).state++;
}

/// Update an existing book and refresh the list.
Future<void> updateBookAction(WidgetRef ref, BookEntity book) async {
  final repo = ref.read(booksRepositoryProvider);
  await repo.updateBook(book);
  ref.read(_booksRefreshProvider.notifier).state++;
}

/// Delete a book and refresh the list.
Future<void> deleteBookAction(WidgetRef ref, String bookId) async {
  final repo = ref.read(booksRepositoryProvider);
  await repo.deleteBook(bookId);
  ref.read(_booksRefreshProvider.notifier).state++;
}
