import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_breeds_app/config/config_imports.dart';
import 'package:cat_breeds_app/config/assets.dart';
import 'package:flutter/material.dart';

class BreedImage extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  const BreedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) return _placeholder();

    // Decode at display size so images stay in the memory cache while scrolling
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      height: height,
      width: width,
      fit: fit,
      memCacheWidth: _toCacheSize(width, pixelRatio),
      memCacheHeight:
          _hasSize(width) ? null : _toCacheSize(height, pixelRatio),
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (context, url) => SizedBox(
        height: height,
        width: width,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      ),
      errorWidget: (context, url, error) => _placeholder(),
    );
  }

  bool _hasSize(double? size) => size != null && size.isFinite;

  int? _toCacheSize(double? size, double pixelRatio) {
    if (!_hasSize(size)) return null;
    return (size! * pixelRatio).round();
  }

  Widget _placeholder() {
    return Image.asset(
      AppAssets.catPlaceholder,
      height: height,
      width: width,
      fit: fit,
    );
  }
}
