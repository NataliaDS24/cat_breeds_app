import 'package:cat_breeds_app/config/config_imports.dart';
import 'package:flutter/material.dart';

class StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const StatTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.textPrimaryInterSemiBold14,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.textSecondaryInterRegular12,
          ),
        ],
      ),
    );
  }
}
