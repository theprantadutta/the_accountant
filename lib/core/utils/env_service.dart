import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvService {
  // NOTE: The Gemini API key getter was removed. Premium AI now runs server-side behind
  // POST /ai/insights ([PremiumRequired]); the app must not ship an AI provider key. Remove
  // GEMINI_API_KEY from the bundled .env / assets as well.

  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }
}
