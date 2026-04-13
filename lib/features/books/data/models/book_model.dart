import 'package:library_management_app/features/books/domain/entities/book_entity.dart';

/// Data-layer model for [BookEntity] with JSON serialisation.
class BookModel extends BookEntity {
  const BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.isbn,
    required super.genre,
    super.description,
    super.coverUrl,
    required super.totalCopies,
    required super.availableCopies,
    required super.createdAt,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      isbn: json['isbn'] as String,
      genre: json['genre'] as String,
      description: json['description'] as String?,
      coverUrl: json['cover_url'] as String?,
      totalCopies: (json['total_copies'] as num).toInt(),
      availableCopies: (json['available_copies'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'genre': genre,
      'description': description,
      'cover_url': coverUrl,
      'total_copies': totalCopies,
      'available_copies': availableCopies,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory BookModel.fromEntity(BookEntity entity) {
    return BookModel(
      id: entity.id,
      title: entity.title,
      author: entity.author,
      isbn: entity.isbn,
      genre: entity.genre,
      description: entity.description,
      coverUrl: entity.coverUrl,
      totalCopies: entity.totalCopies,
      availableCopies: entity.availableCopies,
      createdAt: entity.createdAt,
    );
  }
}
