import 'package:cat_breeds_app/config/config_imports.dart';
import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String label;
  const TagChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.primaryInterMedium12,
      ),
    );
  }
}
