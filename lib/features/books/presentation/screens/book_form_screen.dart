import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/core/utils/error_handler.dart';
import 'package:library_management_app/features/books/domain/entities/book_entity.dart';
import 'package:library_management_app/features/books/presentation/providers/books_provider.dart';

/// Form screen for adding or editing a book.
///
/// When [book] is null, the form runs in create mode.
/// When [book] is provided, it pre-fills all fields for editing.
class BookFormScreen extends ConsumerStatefulWidget {
  const BookFormScreen({super.key, this.book});

  final BookEntity? book;

  bool get isEditing => book != null;

  @override
  ConsumerState<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends ConsumerState<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _authorCtrl;
  late final TextEditingController _isbnCtrl;
  late final TextEditingController _genreCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _copiesCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final b = widget.book;
    _titleCtrl = TextEditingController(text: b?.title ?? '');
    _authorCtrl = TextEditingController(text: b?.author ?? '');
    _isbnCtrl = TextEditingController(text: b?.isbn ?? '');
    _genreCtrl = TextEditingController(text: b?.genre ?? '');
    _descCtrl = TextEditingController(text: b?.description ?? '');
    _copiesCtrl = TextEditingController(
        text: b != null ? '${b.totalCopies}' : '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _isbnCtrl.dispose();
    _genreCtrl.dispose();
    _descCtrl.dispose();
    _copiesCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final copies = int.parse(_copiesCtrl.text.trim());
    final book = BookEntity(
      id: widget.book?.id ?? 'book-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleCtrl.text.trim(),
      author: _authorCtrl.text.trim(),
      isbn: _isbnCtrl.text.trim(),
      genre: _genreCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty
          ? null
          : _descCtrl.text.trim(),
      totalCopies: copies,
      availableCopies: widget.book?.availableCopies ?? copies,
      createdAt: widget.book?.createdAt ?? DateTime.now(),
    );

    try {
      if (widget.isEditing) {
        await updateBookAction(ref, book);
      } else {
        await addBookAction(ref, book);
      }

      if (mounted) {
        showSuccessSnackBar(
          context,
          widget.isEditing
              ? 'Book updated successfully'
              : 'Book added to catalogue',
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        showErrorSnackBar(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Book' : 'Add New Book'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Title ──
              _buildField(
                controller: _titleCtrl,
                label: 'Title',
                icon: Icons.title_rounded,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),

              // ── Author ──
              _buildField(
                controller: _authorCtrl,
                label: 'Author',
                icon: Icons.person_outline,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Author is required' : null,
              ),
              const SizedBox(height: 16),

              // ── ISBN ──
              _buildField(
                controller: _isbnCtrl,
                label: 'ISBN',
                icon: Icons.qr_code_rounded,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'ISBN is required' : null,
              ),
              const SizedBox(height: 16),

              // ── Genre ──
              _buildField(
                controller: _genreCtrl,
                label: 'Genre',
                icon: Icons.category_outlined,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Genre is required' : null,
              ),
              const SizedBox(height: 16),

              // ── Total Copies ──
              _buildField(
                controller: _copiesCtrl,
                label: 'Total Copies',
                icon: Icons.inventory_2_outlined,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Number of copies is required';
                  }
                  final n = int.tryParse(v.trim());
                  if (n == null || n < 1) {
                    return 'Must be at least 1';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Description ──
              _buildField(
                controller: _descCtrl,
                label: 'Description (optional)',
                icon: Icons.description_outlined,
                maxLines: 4,
              ),
              const SizedBox(height: 28),

              // ── Save Button ──
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _onSave,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(widget.isEditing
                          ? Icons.save_rounded
                          : Icons.add_rounded),
                  label: Text(
                    widget.isEditing ? 'Save Changes' : 'Add Book',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
        ),
      ),
    );
  }
}
