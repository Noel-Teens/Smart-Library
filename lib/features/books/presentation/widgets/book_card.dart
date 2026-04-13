import 'package:flutter/material.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/features/books/domain/entities/book_entity.dart';
import 'package:library_management_app/features/books/presentation/widgets/availability_badge.dart';

/// A card widget displaying a book's cover placeholder, title,
/// author, and availability status.
class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
  });

  final BookEntity book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Cover Placeholder ──
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _gradientForGenre(book.genre),
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      book.title.isNotEmpty
                          ? book.title[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.genre,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white54,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Details ──
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const Spacer(),
                    AvailabilityBadge(
                      available: book.availableCopies,
                      total: book.totalCopies,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns a pair of gradient colours based on genre so the
  /// placeholder covers look varied and colourful.
  List<Color> _gradientForGenre(String genre) {
    switch (genre.toLowerCase()) {
      case 'fiction':
        return [const Color(0xFF4A6CF7), const Color(0xFF6366F1)];
      case 'dystopian':
        return [const Color(0xFF6B21A8), const Color(0xFF9333EA)];
      case 'romance':
        return [const Color(0xFFDB2777), const Color(0xFFF472B6)];
      case 'computer science':
        return [const Color(0xFF0891B2), const Color(0xFF22D3EE)];
      case 'science':
        return [const Color(0xFF059669), const Color(0xFF34D399)];
      case 'science fiction':
        return [const Color(0xFF7C3AED), const Color(0xFFA78BFA)];
      case 'history':
        return [const Color(0xFFB45309), const Color(0xFFFBBF24)];
      case 'self-help':
        return [const Color(0xFFEA580C), const Color(0xFFFB923C)];
      case 'psychology':
        return [const Color(0xFF0D9488), const Color(0xFF5EEAD4)];
      case 'philosophy':
        return [const Color(0xFF64748B), const Color(0xFF94A3B8)];
      case 'memoir':
        return [const Color(0xFFBE185D), const Color(0xFFFDA4AF)];
      default:
        return [AppColors.primary700, AppColors.primary500];
    }
  }
}
