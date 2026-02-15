// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CreditsProvider with ChangeNotifier {
//   static const String _creditsKey = 'user_credits';
//   int _credits = 0;

//   CreditsProvider() {
//     _loadCredits();
//   }

//   int get credits => _credits;

//   Future<void> _loadCredits() async {
//     final prefs = await SharedPreferences.getInstance();
//     _credits = prefs.getInt(_creditsKey) ?? 0;
//     notifyListeners();
//   }

//   Future<void> addCredits(int amount) async {
//     if (amount < 0) return;
//     _credits += amount;
//     await _saveCredits();
//     notifyListeners();
//   }

//   Future<void> deductCredits(int amount) async {
//     if (amount < 0) return;
//     _credits -= amount;
//     if (_credits < 0) _credits = 0;
//     await _saveCredits();
//     notifyListeners();
//   }

//   Future<void> _saveCredits() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(_creditsKey, _credits);
//   }

//   // For demo purposes, a reset function might be useful
//   Future<void> resetCredits() async {
//     _credits = 0;
//     await _saveCredits();
//     notifyListeners();
//   }
// }
