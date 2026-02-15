import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiPricingService {
  static const String _apiKey =
      'AIzaSyAJyiyMRc7QtRKQeJije2ioAegozYe-r5Y'; // ← حط مفتاحك هنا
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  static Future<Map<String, dynamic>?> getPricingSuggestion({
    required String medicineName,
    required String activeIngredient,
    required int daysUntilExpiry,
    required String demandLevel, // 'High', 'Medium', 'Low'
    required int quantity,
    required double originalPrice,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": """
You are a pharmacy pricing expert in B2B marketplace.

Given the following:
Medicine: $medicineName
Active Ingredient: $activeIngredient
Days until expiry: $daysUntilExpiry
Demand level: $demandLevel
Quantity: $quantity units
Original price: $originalPrice EGP

Determine the **enforced maximum price** (the highest allowed selling price) and discount percentage.
The price must be lower than or equal to original price, and lower when expiry is closer or demand is low.

Respond **only** with valid JSON:
{
  "enforced_price": number,
  "discount_percentage": number,
  "risk_level": "Low" or "Medium" or "High",
  "explanation": "short explanation in English"
}

No extra text outside the JSON.
"""
                }
              ]
            }
          ],
          "generationConfig": {"temperature": 0.7, "maxOutputTokens": 300}
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];

        // Gemini sometimes wraps JSON in ```json ... ```
        final cleanJson =
            text.replaceAll('```json', '').replaceAll('```', '').trim();

        return jsonDecode(cleanJson);
      } else {
        print('Gemini Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
