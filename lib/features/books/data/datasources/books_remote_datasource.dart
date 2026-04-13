import 'package:library_management_app/features/books/data/models/book_model.dart';

/// Contract for the books remote data source.
abstract class BooksRemoteDataSource {
  Future<List<BookModel>> getAllBooks();
  Future<List<BookModel>> searchBooks(String query);
  Future<BookModel?> getBookById(String id);
  Future<bool> requestBook(String bookId, String userId);
  Future<void> addBook(BookModel book);
  Future<void> updateBook(BookModel book);
  Future<void> deleteBook(String bookId);
}
