import 'package:library_management_app/features/books/domain/entities/book_entity.dart';
import 'package:library_management_app/features/books/domain/repositories/books_repository.dart';

/// Use case: Get real-time availability for a specific book.
class GetBookAvailability {
  const GetBookAvailability(this._repository);

  final BooksRepository _repository;

  /// Returns the book entity with up-to-date availability counts.
  Future<BookEntity?> call(String bookId) {
    return _repository.getBookById(bookId);
  }
}
