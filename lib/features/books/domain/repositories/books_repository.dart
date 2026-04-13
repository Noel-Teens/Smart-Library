import 'package:library_management_app/features/books/domain/entities/book_entity.dart';

/// Abstract contract for book catalogue operations.
abstract class BooksRepository {
  /// Returns all books in the catalogue.
  Future<List<BookEntity>> getAllBooks();

  /// Returns books matching the search [query] (title, author, ISBN, genre).
  Future<List<BookEntity>> searchBooks(String query);

  /// Returns a single book by ID.
  Future<BookEntity?> getBookById(String id);

  /// Submits a borrow request for the book.
  /// Returns `true` if the request was recorded successfully.
  Future<bool> requestBook(String bookId, String userId);

  /// Adds a new book to the catalogue.
  Future<void> addBook(BookEntity book);

  /// Updates an existing book's details.
  Future<void> updateBook(BookEntity book);

  /// Removes a book from the catalogue.
  Future<void> deleteBook(String bookId);
}
