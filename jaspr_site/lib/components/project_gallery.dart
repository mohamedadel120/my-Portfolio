import 'package:jaspr/jaspr.dart';

import 'shot_gallery.dart';

/// The screenshot gallery as its own interactive island, for pages that are
/// otherwise static (the case study pages). It must not be placed inside
/// another `@client` component: Jaspr does not hydrate nested islands, which
/// is why the showcases use [ShotGalleryView] directly instead.
@client
class ProjectGallery extends StatelessComponent {
  final String title;
  final List<String> images;

  const ProjectGallery({super.key, required this.title, required this.images});

  @override
  Component build(BuildContext context) => ShotGalleryView(title: title, images: images, eagerFirst: true);
}
