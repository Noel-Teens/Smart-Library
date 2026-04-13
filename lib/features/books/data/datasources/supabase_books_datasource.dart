import 'package:library_management_app/core/config/supabase_config.dart';
import 'package:library_management_app/features/books/data/datasources/books_remote_datasource.dart';
import 'package:library_management_app/features/books/data/models/book_model.dart';

/// Supabase implementation of [BooksRemoteDataSource].
class SupabaseBooksDataSource implements BooksRemoteDataSource {
  final _client = SupabaseConfig.client;

  @override
  Future<List<BookModel>> getAllBooks() async {
    final data = await _client
        .from('books')
        .select()
        .order('created_at', ascending: false);
    return data.map<BookModel>((json) => BookModel.fromJson(json)).toList();
  }

  @override
  Future<List<BookModel>> searchBooks(String query) async {
    final q = '%$query%';
    final data = await _client
        .from('books')
        .select()
        .or('title.ilike.$q,author.ilike.$q,isbn.ilike.$q,genre.ilike.$q')
        .order('title');
    return data.map<BookModel>((json) => BookModel.fromJson(json)).toList();
  }

  @override
  Future<BookModel?> getBookById(String id) async {
    try {
      final data = await _client
          .from('books')
          .select()
          .eq('id', id)
          .single();
      return BookModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> requestBook(String bookId, String userId) async {
    // Creating a transaction is the actual request — handled by transactions datasource.
    // This is kept for interface compatibility.
    return true;
  }

  @override
  Future<void> addBook(BookModel book) async {
    await _client.from('books').insert({
      'title': book.title,
      'author': book.author,
      'isbn': book.isbn,
      'genre': book.genre,
      'description': book.description,
      'cover_url': book.coverUrl,
      'total_copies': book.totalCopies,
      'available_copies': book.availableCopies,
    });
  }

  @override
  Future<void> updateBook(BookModel book) async {
    await _client.from('books').update({
      'title': book.title,
      'author': book.author,
      'isbn': book.isbn,
      'genre': book.genre,
      'description': book.description,
      'cover_url': book.coverUrl,
      'total_copies': book.totalCopies,
      'available_copies': book.availableCopies,
    }).eq('id', book.id);
  }

  @override
  Future<void> deleteBook(String bookId) async {
    await _client.from('books').delete().eq('id', bookId);
  }
}
