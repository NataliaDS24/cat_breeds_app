import 'package:cat_breeds_app/config/config_imports.dart';

extension BoolExtensions on bool {
  String get getStringValue {
    switch (this) {
      case false:
        return AppStrings.yes;
      case true:
        return AppStrings.not;
      default:
        return AppStrings.not;
    }
  }
}
