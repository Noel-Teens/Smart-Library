import 'package:library_management_app/features/books/domain/repositories/books_repository.dart';

/// Use case: Submit a borrow request for a book.
class RequestBook {
  const RequestBook(this._repository);

  final BooksRepository _repository;

  Future<bool> call({required String bookId, required String userId}) {
    return _repository.requestBook(bookId, userId);
  }
}
