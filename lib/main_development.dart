import 'package:cat_breeds_app/config/env.dart';
import 'package:cat_breeds_app/main.dart';

void main() async {
  Env.environment = Environment.development;
  await runCatBreedsApp();
}
