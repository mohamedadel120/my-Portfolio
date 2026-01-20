import 'package:flutter/material.dart';

class Project {
  final String title;
  final String description;
  final List<String> tech;
  final Color color;
  final String downloads;
  final String? imageUrl;
  final String? logoUrl;
  final List<String>? galleryImages;
  final String? androidStoreUrl;
  final String? iosStoreUrl;
  final String? videoUrl;

  const Project({
    required this.title,
    required this.description,
    required this.tech,
    required this.color,
    required this.downloads,
    this.imageUrl,
    this.logoUrl,
    this.galleryImages,
    this.androidStoreUrl,
    this.iosStoreUrl,
    this.videoUrl,
  });
}
