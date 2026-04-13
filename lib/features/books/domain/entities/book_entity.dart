import 'package:equatable/equatable.dart';

/// Domain entity representing a book in the catalogue.
class BookEntity extends Equatable {
  const BookEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.genre,
    this.description,
    this.coverUrl,
    required this.totalCopies,
    required this.availableCopies,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String author;
  final String isbn;
  final String genre;
  final String? description;
  final String? coverUrl;
  final int totalCopies;
  final int availableCopies;
  final DateTime createdAt;

  /// Whether at least one copy is available for borrowing.
  bool get isAvailable => availableCopies > 0;

  /// Human-readable availability label: '3 / 5 copies available'.
  String get availabilityLabel => '$availableCopies / $totalCopies available';

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        isbn,
        genre,
        description,
        coverUrl,
        totalCopies,
        availableCopies,
        createdAt,
      ];

  BookEntity copyWith({
    String? id,
    String? title,
    String? author,
    String? isbn,
    String? genre,
    String? description,
    String? coverUrl,
    int? totalCopies,
    int? availableCopies,
    DateTime? createdAt,
  }) {
    return BookEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      totalCopies: totalCopies ?? this.totalCopies,
      availableCopies: availableCopies ?? this.availableCopies,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
