import 'package:flutter/material.dart';

class Medication {
  final String id;
  final String name;
  final String? description;
  final TimeOfDay time;
  bool isActive;

  Medication({
    required this.id,
    required this.name,
    this.description,
    required this.time,
    this.isActive = true,
  });
}