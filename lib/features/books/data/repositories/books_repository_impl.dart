import 'package:library_management_app/features/books/data/datasources/books_remote_datasource.dart';
import 'package:library_management_app/features/books/data/models/book_model.dart';
import 'package:library_management_app/features/books/domain/entities/book_entity.dart';
import 'package:library_management_app/features/books/domain/repositories/books_repository.dart';

/// Concrete implementation of [BooksRepository].
class BooksRepositoryImpl implements BooksRepository {
  const BooksRepositoryImpl(this._dataSource);

  final BooksRemoteDataSource _dataSource;

  @override
  Future<List<BookEntity>> getAllBooks() => _dataSource.getAllBooks();

  @override
  Future<List<BookEntity>> searchBooks(String query) =>
      _dataSource.searchBooks(query);

  @override
  Future<BookEntity?> getBookById(String id) => _dataSource.getBookById(id);

  @override
  Future<bool> requestBook(String bookId, String userId) =>
      _dataSource.requestBook(bookId, userId);

  @override
  Future<void> addBook(BookEntity book) =>
      _dataSource.addBook(BookModel.fromEntity(book));

  @override
  Future<void> updateBook(BookEntity book) =>
      _dataSource.updateBook(BookModel.fromEntity(book));

  @override
  Future<void> deleteBook(String bookId) =>
      _dataSource.deleteBook(bookId);
}
