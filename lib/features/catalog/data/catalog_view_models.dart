import 'package:flutter/material.dart';

class ReferenceRange {
  const ReferenceRange({
    required this.label,
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  final String label;
  final String value;
  final Color color;
  final Color backgroundColor;
}

class HealthTest {
  const HealthTest({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.sampleType,
    required this.tags,
    required this.whatIsIt,
    required this.whyTakeThisTest,
    required this.referenceRanges,
    required this.preparation,
    required this.oftenBookedWith,
  });

  final String id;
  final String name;
  final String subtitle;
  final int price;
  final String sampleType;
  final List<String> tags;
  final String whatIsIt;
  final String whyTakeThisTest;
  final List<ReferenceRange> referenceRanges;
  final String preparation;
  final List<String> oftenBookedWith;

  String get formattedPrice => '₹$price';
}

class HealthCategory {
  const HealthCategory({
    required this.id,
    required this.name,
    required this.testCount,
    required this.icon,
    required this.color,
    required this.tests,
  });

  final String id;
  final String name;
  final int testCount;
  final IconData icon;
  final Color color;
  final List<HealthTest> tests;
}
