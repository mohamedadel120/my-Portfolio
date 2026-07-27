import 'firestore_rest.dart';

const _firestore = FirestoreRest('my-website-bf9e6');

class ProjectItem {
  final String title;
  final String description;
  final List<String> tech;
  final int color;
  final String downloads;
  final String? imageUrl;
  final String? logoUrl;
  final List<String>? galleryImages;
  final String? androidStoreUrl;
  final String? iosStoreUrl;
  final String? videoUrl;

  const ProjectItem({
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

class ProjectStats {
  final int totalProjects;
  final int totalDownloads;
  final double averageRating;
  final int techStacks;

  const ProjectStats({
    required this.totalProjects,
    required this.totalDownloads,
    required this.averageRating,
    required this.techStacks,
  });
}

Future<List<ProjectItem>> fetchProjects() async {
  final docs = await _firestore.getCollection('projects');
  return docs.map((json) {
    final rawColor = json['color'];
    int color = 0xFF000000;
    if (rawColor is int) {
      color = rawColor;
    } else if (rawColor is String) {
      if (rawColor.startsWith('0x') || rawColor.startsWith('0X')) {
        color = int.tryParse(rawColor.substring(2), radix: 16) ?? color;
      } else {
        color = int.tryParse(rawColor) ?? color;
      }
    }

    return ProjectItem(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      tech: (json['tech'] as List?)?.cast<String>() ?? const [],
      color: color,
      downloads: json['downloads'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      logoUrl: json['logoUrl'] as String?,
      galleryImages: (json['galleryImages'] as List?)?.cast<String>(),
      androidStoreUrl: json['androidStoreUrl'] as String?,
      iosStoreUrl: json['iosStoreUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
    );
  }).toList();
}

/// Ported verbatim from `_getProjectStats`/`_getAllTechStacks` in
/// projects_desktop_view.dart (and its mobile/tablet duplicates): strips
/// non-digits out of the free-text `downloads` field and sums them, and
/// "average rating" is a flat 4.8 counted for any project whose downloads
/// string contains a `+` or `,` — not real per-project ratings. Odd, but
/// that's the actual live logic, not something to "fix" here.
ProjectStats computeProjectStats(List<ProjectItem> projects) {
  var totalDownloads = 0;
  var totalRating = 0.0;
  var ratedProjects = 0;
  final techStacks = <String>{};

  for (final project in projects) {
    final digitsOnly = project.downloads.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isNotEmpty) {
      totalDownloads += int.tryParse(digitsOnly) ?? 0;
    }
    if (project.downloads.contains('+') || project.downloads.contains(',')) {
      totalRating += 4.8;
      ratedProjects++;
    }
    techStacks.addAll(project.tech);
  }

  return ProjectStats(
    totalProjects: projects.length,
    totalDownloads: totalDownloads,
    averageRating: ratedProjects > 0 ? totalRating / ratedProjects : 0.0,
    techStacks: techStacks.length,
  );
}
