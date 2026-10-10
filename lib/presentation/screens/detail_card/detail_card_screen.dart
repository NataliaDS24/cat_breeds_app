import 'package:cat_breeds_app/config/config_imports.dart';
import 'package:cat_breeds_app/core/utils/breed_utils.dart';
import 'package:cat_breeds_app/presentation/screens/detail_card/detail_card_provider.dart';
import 'package:cat_breeds_app/presentation/widgets/breed_image.dart';
import 'package:cat_breeds_app/presentation/widgets/stat_tile.dart';
import 'package:cat_breeds_app/presentation/widgets/tag_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailCard extends StatelessWidget {
  const DetailCard({super.key});

  static const double _imageHeight = 280;

  @override
  Widget build(BuildContext context) {
    final breed = context.watch<DetailCardProvider>().breed;
    final originLabel = breed.originLabel;
    final temperament = breed.temperamentList;
    final history = breed.history ?? AppStrings.voidText;
    final stats = [
      if (breed.lifeSpan.isNotEmpty)
        StatTile(
          icon: Icons.favorite_border,
          label: AppStrings.lifeSpan,
          value: '${breed.lifeSpan} ${AppStrings.yearsUnit}',
        ),
      if (breed.weight.metric.isNotEmpty)
        StatTile(
          icon: Icons.monitor_weight_outlined,
          label: AppStrings.weight,
          value: '${breed.weight.metric} ${AppStrings.kilogramsUnit}',
        ),
      if (breed.height != null && breed.height!.metric.isNotEmpty)
        StatTile(
          icon: Icons.height,
          label: AppStrings.height,
          value: '${breed.height!.metric} ${AppStrings.centimetersUnit}',
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          breed.name,
          style: AppTextStyles.whiteInterBold20,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          // The image stays fixed, only the breed info scrolls
          SizedBox(
            height: _imageHeight,
            width: double.infinity,
            child: Hero(
              tag: breed.heroImageTag,
              child: BreedImage(
                imageUrl: breed.imageUrl,
                width: double.infinity,
                height: _imageHeight,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                if (originLabel.isNotEmpty)
                  Text(
                    originLabel,
                    style: AppTextStyles.textSecondaryInterRegular15,
                  ),
                if (stats.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < stats.length; i++) ...[
                        if (i > 0) const SizedBox(width: 12),
                        Expanded(child: stats[i]),
                      ],
                    ],
                  ),
                ],
                if (temperament.isNotEmpty)
                  _DetailSection(
                    title: AppStrings.temperamentTitle,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: temperament
                          .map((tag) => TagChip(label: tag))
                          .toList(),
                    ),
                  ),
                if (breed.description.isNotEmpty)
                  _DetailSection(
                    title: AppStrings.descriptionTitle,
                    child: Text(
                      breed.description,
                      style: AppTextStyles.textPrimaryInterRegular15,
                    ),
                  ),
                if (history.isNotEmpty)
                  _DetailSection(
                    title: AppStrings.historyTitle,
                    child: Text(
                      history,
                      style: AppTextStyles.textPrimaryInterRegular15,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final Widget child;
  const _DetailSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.textPrimaryInterSemiBold16,
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
