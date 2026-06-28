import 'package:flutter/material.dart';

class ProfileTestItem {
  const ProfileTestItem({
    required this.name,
    required this.subtitle,
    required this.price,
  });

  final String name;
  final String subtitle;
  final int price;
}

class HealthProfileData {
  const HealthProfileData({
    required this.slug,
    required this.name,
    required this.shortName,
    required this.iconAsset,
    required this.testCount,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.color,
    required this.description,
    required this.whatIsItFor,
    required this.highlights,
    required this.whoShouldTakeThis,
    required this.preparation,
    required this.tests,
  });

  final String slug;
  final String name;
  final String shortName;
  final String iconAsset;
  final int testCount;
  final int price;
  final int originalPrice;
  final String discount;
  final Color color;
  final String description;
  final String whatIsItFor;
  final List<String> highlights;
  final String whoShouldTakeThis;
  final List<String> preparation;
  final List<ProfileTestItem> tests;

  String get formattedPrice => '₹$price';
  String get formattedOriginalPrice => '₹$originalPrice';
}
