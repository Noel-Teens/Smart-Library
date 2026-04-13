import 'package:flutter/material.dart';
import 'package:library_management_app/core/theme/app_colors.dart';

/// Status chip showing book availability with semantic colours.
///
/// Maps to the status badge spec in Color Theme Document §7.5.
class AvailabilityBadge extends StatelessWidget {
  const AvailabilityBadge({
    super.key,
    required this.available,
    required this.total,
  });

  final int available;
  final int total;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final Color border;
    final String label;

    if (available == 0) {
      bg = AppColors.error100;
      fg = AppColors.error700;
      border = AppColors.error500;
      label = 'Unavailable';
    } else if (available <= (total * 0.3).ceil()) {
      bg = AppColors.warning100;
      fg = AppColors.warning700;
      border = AppColors.warning500;
      label = '$available left';
    } else {
      bg = AppColors.success100;
      fg = AppColors.success700;
      border = AppColors.success500;
      label = '$available available';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
