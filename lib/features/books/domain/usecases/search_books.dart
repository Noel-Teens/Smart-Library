import 'package:library_management_app/features/books/domain/entities/book_entity.dart';
import 'package:library_management_app/features/books/domain/repositories/books_repository.dart';

/// Use case: Search books by query string.
class SearchBooks {
  const SearchBooks(this._repository);

  final BooksRepository _repository;

  Future<List<BookEntity>> call(String query) {
    return _repository.searchBooks(query);
  }
}
