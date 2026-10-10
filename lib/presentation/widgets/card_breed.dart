import 'package:cat_breeds_app/config/config_imports.dart';
import 'package:cat_breeds_app/config/router/router_path.dart';
import 'package:cat_breeds_app/core/utils/breed_utils.dart';
import 'package:cat_breeds_app/domain/entities/breed.dart';
import 'package:cat_breeds_app/presentation/widgets/breed_image.dart';
import 'package:cat_breeds_app/presentation/widgets/tag_chip.dart';
import 'package:flutter/material.dart';

class CardBreed extends StatelessWidget {
  final Breed breed;
  const CardBreed({
    super.key,
    required this.breed,
  });

  static const double _imageAspectRatio = 16 / 10;
  static const int _maxTemperamentTags = 2;

  List<String> get _temperamentTags {
    final tags = breed.temperamentList;
    if (tags.length <= _maxTemperamentTags) return tags;
    return [
      ...tags.take(_maxTemperamentTags),
      '+${tags.length - _maxTemperamentTags}',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = breed.originLabel;
    final tags = _temperamentTags;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.detailCard,
            arguments: {'breed': breed},
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) => Hero(
                  tag: breed.heroImageTag,
                  child: BreedImage(
                    imageUrl: breed.imageUrl,
                    width: constraints.maxWidth,
                    height: constraints.maxWidth / _imageAspectRatio,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            breed.name,
                            style: AppTextStyles.textPrimaryInterBold18,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTextStyles.textSecondaryInterRegular13,
                      ),
                    ],
                    if (tags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tags
                            .map((tag) => TagChip(label: tag))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
