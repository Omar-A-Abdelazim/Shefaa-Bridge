import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String specs;
  final double price;
  final double? oldPrice;
  final String distance;
  final String pharmacy;
  final String tag;
  final Color tagColor;
  final Color tagTextColor;
  final Color imageColor;
  final String category;
  final double rating;
  final int reviews;
  final String activeIngredient;
  final String expiryDate;
  final int stock;
  final int minOrder;
  final String batchNumber;
  final String storageConditions;
  final String manufacturer;
  final String imagePlaceholder;

  Product({
    required this.id,
    required this.name,
    required this.specs,
    required this.price,
    this.oldPrice,
    required this.distance,
    required this.pharmacy,
    required this.tag,
    required this.tagColor,
    required this.tagTextColor,
    required this.imageColor,
    this.category = 'ANTIBIOTICS',
    this.rating = 4.8,
    this.reviews = 120,
    this.activeIngredient = 'Amoxicillin Trihydrate IP',
    this.expiryDate = 'Nov 2025',
    this.stock = 1250,
    this.minOrder = 50,
    this.batchNumber = '#AMX-2024-0012',
    this.storageConditions = 'Cool & Dry (2-8°C)',
    this.manufacturer = 'PharmaCorp Intl.',
    required this.imagePlaceholder,
  });
}
