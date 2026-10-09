import 'package:cat_breeds_app/config/config_imports.dart';
import 'package:cat_breeds_app/core/utils/bool_utils.dart';
import 'package:cat_breeds_app/presentation/screens/detail_card/detail_card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailCard extends StatelessWidget {
  const DetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DetailCardProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        centerTitle: true,
        title: Text(
          provider.breed.name,
          style: AppTextStyles.whiteInterBold20,
        ),
      ),
      body: Column(
        children: [
          if (provider.breed.imageUrl != null && provider.breed.imageUrl != '')
            Expanded(
              child: Image.network(
                provider.breed.imageUrl!,
                width: double.infinity,
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  provider.breed.description,
                  style: AppTextStyles.blackInterSemiBold16,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${AppStrings.intelligence}${provider.breed.intelligence}',
                  style: AppTextStyles.blackInterSemiBold16,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${AppStrings.origin}${provider.breed.origin}',
                  style: AppTextStyles.blackInterSemiBold16,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${AppStrings.temperament}${provider.breed.temperament}',
                  style: AppTextStyles.blackInterSemiBold16,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${AppStrings.metric}${provider.breed.weight.metric}',
                  style: AppTextStyles.blackInterSemiBold16,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${AppStrings.imperial}${provider.breed.weight.imperial}',
                  style: AppTextStyles.blackInterSemiBold16,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${AppStrings.affectionLevel}${provider.breed.affectionLevel}',
                  style: AppTextStyles.blackInterSemiBold16,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${AppStrings.energyLevel}${provider.breed.energyLevel}',
                  style: AppTextStyles.blackInterSemiBold16,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${AppStrings.healthIssues}${provider.breed.healthIssues}',
                  style: AppTextStyles.blackInterSemiBold16,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${AppStrings.socialNeeds}${provider.breed.socialNeeds}',
                  style: AppTextStyles.blackInterSemiBold16,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${AppStrings.rare}${provider.breed.rare.getStringValue}',
                  style: AppTextStyles.blackInterSemiBold16,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${AppStrings.natural}${provider.breed.natural.getStringValue}',
                  style: AppTextStyles.blackInterSemiBold16,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${AppStrings.shortLegs}${provider.breed.shortLegs}',
                  style: AppTextStyles.blackInterSemiBold16,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${AppStrings.hypoallergenic}${provider.breed.hypoallergenic}',
                  style: AppTextStyles.blackInterSemiBold16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
