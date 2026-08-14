import 'package:flutter/material.dart';
import 'package:bft_calculator/constants/app_constants.dart';

/// Widget to display percentage with progress bar and color-coded indicator
class PercentageRow extends StatelessWidget {
  final String label;
  final double percentage;

  const PercentageRow({
    super.key,
    required this.label,
    required this.percentage,
  });

  /// Get color based on percentage score
  Color _getPercentageColor() {
    if (percentage >= 80) return AppColors.progressGreen;
    if (percentage >= 60) return AppColors.progressBlue;
    return AppColors.progressOrange;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: _getPercentageColor(),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.small),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getPercentageColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
