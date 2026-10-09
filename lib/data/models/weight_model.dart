import 'package:cat_breeds_app/config/config_imports.dart';
import 'package:cat_breeds_app/domain/entities/weight.dart';

class WeightModel extends Weight {
  WeightModel({
    required super.imperial,
    required super.metric,
  });

  factory WeightModel.fromMap({required Map map}) {
    return WeightModel(
      imperial: map['imperial'] ?? AppStrings.voidText,
      metric: map['metric'] ?? AppStrings.voidText,
    );
  }
}
