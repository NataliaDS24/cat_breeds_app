import 'package:cat_breeds_app/config/config_imports.dart';
import 'package:cat_breeds_app/core/utils/int_utils.dart';
import 'package:cat_breeds_app/data/models/weight_model.dart';
import 'package:cat_breeds_app/domain/entities/breed.dart';

class BreedModel extends Breed {
  BreedModel({
    required super.id,
    required super.weight,
    required super.name,
    super.cfaUrl,
    super.vetstreetUrl,
    super.vcahospitalsUrl,
    required super.temperament,
    required super.origin,
    required super.countryCodes,
    required super.countryCode,
    required super.description,
    required super.lifeSpan,
    required super.indoor,
    super.lap,
    super.altNames,
    required super.adaptability,
    required super.affectionLevel,
    required super.childFriendly,
    required super.dogFriendly,
    required super.energyLevel,
    required super.grooming,
    required super.healthIssues,
    required super.intelligence,
    required super.sheddingLevel,
    required super.socialNeeds,
    required super.strangerFriendly,
    required super.vocalisation,
    required super.experimental,
    required super.hairless,
    required super.natural,
    required super.rare,
    required super.rex,
    required super.suppressedTail,
    required super.shortLegs,
    super.wikipediaUrl,
    required super.hypoallergenic,
    super.referenceImageId,
    super.imageUrl,
  });

  factory BreedModel.fromMap({required Map map}) {
    int vocalisation = map['vocalisation'] ?? 0;
    int experimental = map['experimental'] ?? 0;
    int hairless = map['hairless'] ?? 0;
    int natural = map['natural'] ?? 0;
    int rare = map['rare'] ?? 0;
    int rex = map['rex'] ?? 0;
    int suppressedTail = map['suppressed_tail'] ?? 0;
    int shortLegs = map['short_legs'] ?? 0;
    int hypoallergenic = map['hypoallergenic'] ?? 0;
    return BreedModel(
      id: map['id'] ?? AppStrings.voidText,
      weight: WeightModel.fromMap(map: map['weight']),
      name: map['name'] ?? AppStrings.voidText,
      cfaUrl: map['cfa_url'],
      vetstreetUrl: map['vetstreet_url'],
      vcahospitalsUrl: map['vcahospitals_url'],
      temperament: map['temperament'] ?? AppStrings.voidText,
      origin: map['origin'] ?? AppStrings.voidText,
      countryCodes: map['country_codes'] ?? AppStrings.voidText,
      countryCode: map['country_code'] ?? AppStrings.voidText,
      description: map['description'] ?? AppStrings.voidText,
      lifeSpan: map['life_span'] ?? AppStrings.voidText,
      indoor: map['indoor'] ?? 0,
      altNames: map['alt_names'] ?? AppStrings.voidText,
      adaptability: map['adaptability'] ?? 0,
      affectionLevel: map['affection_level'] ?? 0,
      childFriendly: map['child_friendly'] ?? 0,
      dogFriendly: map['dog_friendly'] ?? 0,
      energyLevel: map['energy_level'] ?? 0,
      grooming: map['grooming'] ?? 0,
      healthIssues: map['health_issues'] ?? 0,
      intelligence: map['intelligence'] ?? 0,
      sheddingLevel: map['shedding_level'] ?? 0,
      socialNeeds: map['social_needs'] ?? 0,
      strangerFriendly: map['stranger_friendly'] ?? 0,
      vocalisation: vocalisation.getBoolValue,
      experimental: experimental.getBoolValue,
      hairless: hairless.getBoolValue,
      natural: natural.getBoolValue,
      rare: rare.getBoolValue,
      rex: rex.getBoolValue,
      suppressedTail: suppressedTail.getBoolValue,
      shortLegs: shortLegs.getBoolValue,
      wikipediaUrl: map['wikipedia_url'],
      hypoallergenic: hypoallergenic.getBoolValue,
      referenceImageId: map['reference_image_id'] ?? AppStrings.voidText,
      imageUrl: map['image']?['url'],
    );
  }
}
