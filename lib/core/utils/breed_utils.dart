import 'package:cat_breeds_app/core/utils/string_utils.dart';
import 'package:cat_breeds_app/domain/entities/breed.dart';

extension BreedExtensions on Breed {
  
  String get originLabel {
    final originWithFlag = [
      countryCode.toFlagEmoji,
      origin,
    ].where((value) => value.isNotEmpty).join(' ');
    return [
      originWithFlag,
      breedGroup ?? '',
    ].where((value) => value.isNotEmpty).join(' · ');
  }

  String get heroImageTag => 'breed-image-$id';

  List<String> get temperamentList => temperament
      .split(',')
      .map((tag) => tag.trim())
      .where((tag) => tag.isNotEmpty)
      .toList();
}
