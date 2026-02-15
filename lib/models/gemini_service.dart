// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'dart:convert';

// class GeminiService {
//   final String _apiKey;
//   late final GenerativeModel _model;

//   GeminiService(this._apiKey) {
//     _model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
//   }

//   Future<Map<String, dynamic>?> getMedicinePricing({
//     required String medicineName,
//     required int daysUntilExpiry,
//     required int quantity,
//     required String demandLevel,
//   }) async {
//     final prompt = '''
//       You are an AI assistant for a B2B pharmacy marketplace. Your task is to estimate medicine pricing and risk levels based on provided details.
//       Return the response in JSON format only, with the following keys:
//       - market_price_egp (estimated real market price in Egyptian Pounds, float)
//       - enforced_price_egp (maximum allowed selling price after discount, float)
//       - discount_percentage (float)
//       - risk_level (Low / Medium / High, string)
//       - explanation (short explanation in English, string)

//       Input Details:
//       Medicine Name: $medicineName
//       Days Until Expiry: $daysUntilExpiry
//       Quantity: $quantity
//       Demand Level: $demandLevel

//       Consider factors like expiry date proximity (closer expiry means higher discount), quantity (bulk might get better pricing), and demand level.
//       Ensure the enforced_price_egp is always less than or equal to market_price_egp.
//       The discount_percentage should be calculated based on market_price_egp and enforced_price_egp.
//       ''';

//     try {
//       final content = [Content.text(prompt)];
//       final response = await _model.generateContent(content);

//       if (response.text != null) {
//         // Attempt to parse the JSON string from the response
//         final jsonString = response.text!.replaceAll('```json', '').replaceAll('```', '').trim();
//         final Map<String, dynamic> result = jsonDecode(jsonString);
//         return result;
//       }
//     } catch (e) {
//       print('Error calling Gemini API: $e');
//     }
//     return null;
//   }
// }
