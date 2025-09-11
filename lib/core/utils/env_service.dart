import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvService {
  static String get geminiApiKey {
    return dotenv.env['GEMINI_API_KEY'] ?? '';
  }

  static String get premiumProductId {
    return dotenv.env['PREMIUM_PRODUCT_ID'] ?? 'premium_features';
  }

  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }
}
