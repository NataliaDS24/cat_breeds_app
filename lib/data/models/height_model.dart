import 'package:cat_breeds_app/config/config_imports.dart';
import 'package:cat_breeds_app/domain/entities/height.dart';

class HeightModel extends Height {
  HeightModel({
    required super.imperial,
    required super.metric,
  });

  factory HeightModel.fromMap({required Map map}) {
    return HeightModel(
      imperial: map['imperial'] ?? AppStrings.voidText,
      metric: map['metric'] ?? AppStrings.voidText,
    );
  }
}
