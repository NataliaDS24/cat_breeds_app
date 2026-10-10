import 'package:cat_breeds_app/config/config_imports.dart';
import 'package:cat_breeds_app/config/router/router_path.dart';
import 'package:cat_breeds_app/domain/entities/breed.dart';
import 'package:cat_breeds_app/presentation/widgets/breed_image.dart';
import 'package:flutter/material.dart';

class CardBreed extends StatelessWidget {
  final Breed breed;
  const CardBreed({
    super.key,
    required this.breed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.detailCard,
          arguments: {'breed': breed}),
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            20,
          ),
          color: AppColors.floralLinen,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  breed.name,
                  style: AppTextStyles.blackInterBold18,
                ),
                const Text(
                  AppStrings.more,
                  style: AppTextStyles.blackInterSemiBold16,
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.carrotOrange,
                  width: 10,
                ),
              ),
              child: BreedImage(
                imageUrl: breed.imageUrl,
                height: 200,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  breed.origin,
                  style: AppTextStyles.blackInterSemiBold16,
                ),
                Text(
                  '${AppStrings.intelligence}${breed.intelligence}',
                  style: AppTextStyles.blackInterSemiBold16,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
