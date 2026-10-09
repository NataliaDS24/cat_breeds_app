import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { development, production }

class Env {
  static Env? _instance;
  Env._();

  static Env get instance => _instance ??= Env._();
  static late final Environment environment;

  // Environment variables
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  static Future<void> init() async {
    switch (environment) {
      case Environment.development:
        await dotenv.load(fileName: ".env_development");
        break;
      default:
        await dotenv.load(fileName: ".env");
        break;
    }
  }
}
