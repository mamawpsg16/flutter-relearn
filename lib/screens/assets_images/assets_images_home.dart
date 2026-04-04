import 'package:flutter/material.dart';
import 'specifying_assets_screen.dart';
import 'loading_images_screen.dart';
import 'resolution_aware_screen.dart';
import 'loading_text_assets_screen.dart';
import 'fade_in_image_screen.dart';
import 'video_player_screen.dart';
import 'transform_assets_screen.dart';
import 'youtube_player_screen.dart';

class AssetsImagesHome extends StatelessWidget {
  const AssetsImagesHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Specifying Assets',
        description: 'Declare assets in pubspec.yaml so Flutter bundles them',
        icon: Icons.folder_open,
        color: Colors.amber,
        screen: const SpecifyingAssetsScreen(),
      ),
      _Topic(
        title: 'Loading Images',
        description: 'Display bundled or network images with Image widget',
        icon: Icons.image,
        color: Colors.blue,
        screen: const LoadingImagesScreen(),
      ),
      _Topic(
        title: 'Resolution-Aware Images',
        description: 'Serve 1x / 2x / 3x variants for different pixel densities',
        icon: Icons.photo_size_select_actual,
        color: Colors.green,
        screen: const ResolutionAwareScreen(),
      ),
      _Topic(
        title: 'Loading Text Assets',
        description: 'Read JSON, CSV, and text files at runtime with rootBundle',
        icon: Icons.text_snippet,
        color: Colors.purple,
        screen: const LoadingTextAssetsScreen(),
      ),
      _Topic(
        title: 'Fade In Images',
        description: 'Show a placeholder while loading, then fade in the real image',
        icon: Icons.blur_on,
        color: Colors.orange,
        screen: const FadeInImageScreen(),
      ),
      _Topic(
        title: 'Play & Pause a Video',
        description: 'Use the video_player package to stream and control video',
        icon: Icons.play_circle,
        color: Colors.red,
        screen: const VideoPlayerScreen(),
      ),
      _Topic(
        title: 'Transform Assets at Build Time',
        description: 'Resize, compress, or convert assets automatically during build',
        icon: Icons.build,
        color: Colors.brown,
        screen: const TransformAssetsScreen(),
      ),
      _Topic(
        title: 'YouTube Player',
        description: 'Embed & control YouTube videos using youtube_player_iframe',
        icon: Icons.smart_display,
        color: Colors.red,
        screen: const YoutubePlayerScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets & Images'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        separatorBuilder: (_, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final topic = topics[index];
          return _TopicCard(topic: topic);
        },
      ),
    );
  }
}

class _Topic {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget screen;

  const _Topic({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.screen,
  });
}

class _TopicCard extends StatelessWidget {
  final _Topic topic;

  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: topic.color,
          child: Icon(topic.icon, color: Colors.white),
        ),
        title: Text(
          topic.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(topic.description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => topic.screen),
          );
        },
      ),
    );
  }
}
