import 'package:cat_breeds_app/config/config_imports.dart';

extension BoolExtensions on bool {
  String get getStringValue {
    return this ? AppStrings.yes : AppStrings.not;
  }
}
