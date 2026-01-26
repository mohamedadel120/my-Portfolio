import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Expertise extends Equatable {
  final String title;
  final String description;
  final IconData icon;
  final Color? color;

  const Expertise({
    required this.title,
    required this.description,
    required this.icon,
    this.color,
  });

  @override
  List<Object?> get props => [title, description, icon, color];
}
