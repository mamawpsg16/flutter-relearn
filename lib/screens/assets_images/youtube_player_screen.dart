import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerScreen extends StatefulWidget {
  const YoutubePlayerScreen({super.key});

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _controller;

  // Public domain / embedding-enabled videos
  static const _videoId = 'jNQXAC9IVRw';

  static const _playlist = [
    _YtVideo('jNQXAC9IVRw', 'Me at the zoo (first YouTube video ever)'),
    _YtVideo('YE7VzlLtp-4', 'Google I/O 2023 Keynote'),
    _YtVideo('dQw4w9WgXcQ', 'Rick Astley — Never Gonna Give You Up'),
  ];

  String _currentId = _videoId;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: _videoId,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void _loadVideo(String videoId) {
    _controller.loadVideoById(videoId: videoId);
    setState(() => _currentId = videoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Player'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Concept explanation ──────────────────────────────────────
          const Text(
            'YouTube videos cannot be played with video_player because YouTube '
            'uses protected streaming (DRM). The youtube_player_iframe package '
            'embeds the official YouTube IFrame player inside a WebView, giving '
            'you full playback controls without violating YouTube\'s Terms of Service.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),

          // ── BAD code ─────────────────────────────────────────────────
          const _CodeSection(
            label: 'BAD — trying to use video_player with a YouTube URL',
            labelColor: Colors.red,
            code: '''// ❌ This will NOT work — YouTube URLs are not direct video files
VideoPlayerController.networkUrl(
  Uri.parse('https://www.youtube.com/watch?v=rqx5NlvEEUE'),
)
// Results in: "Invalid video" or silent failure''',
          ),
          const SizedBox(height: 12),

          // ── GOOD code ────────────────────────────────────────────────
          const _CodeSection(
            label: 'GOOD — use youtube_player_iframe',
            labelColor: Colors.green,
            code: '''// 1. pubspec.yaml:
//    youtube_player_iframe: ^4.0.0

// 2. Extract just the video ID from the URL:
//    https://youtube.com/watch?v=rqx5NlvEEUE
//                                ^^^^^^^^^^^
//                                this part only

// 3. Create the controller:
final controller = YoutubePlayerController.fromVideoId(
  videoId: 'rqx5NlvEEUE',
  params: const YoutubePlayerParams(
    showControls: true,
    showFullscreenButton: true,
  ),
);

// 4. Embed the player:
YoutubePlayer(controller: controller)

// 5. Switch videos at runtime:
controller.loadVideoById(videoId: 'anotherVideoId');

// 6. Always dispose:
@override
void dispose() {
  controller.close();  // not .dispose() — it's .close()
  super.dispose();
}''',
          ),
          const SizedBox(height: 24),

          // ── Live demo ─────────────────────────────────────────────────
          const Text(
            'Live Demo',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'The video you shared — plus two more Flutter videos to try:',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),

          // Video selector
          ..._playlist.map((v) {
            final isSelected = _currentId == v.id;
            return Card(
              color: isSelected ? Colors.red.shade50 : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? Colors.red : Colors.grey.shade300,
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isSelected ? Colors.red : Colors.grey,
                  child: Icon(
                    isSelected ? Icons.play_arrow : Icons.play_circle_outline,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  v.title,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  'youtube.com/watch?v=${v.id}',
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
                onTap: () => _loadVideo(v.id),
              ),
            );
          }),
          const SizedBox(height: 16),

          // The actual YouTube player
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(controller: _controller),
            ),
          ),
          const SizedBox(height: 8),
          // Fallback — always works regardless of WebView issues
          OutlinedButton.icon(
            onPressed: () => launchUrl(
              Uri.parse('https://www.youtube.com/watch?v=$_currentId'),
              mode: LaunchMode.externalApplication,
            ),
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('Open in YouTube app instead'),
          ),
          const SizedBox(height: 24),

          // ── video_player vs youtube_player comparison ──────────────────
          const Text(
            'video_player vs youtube_player_iframe',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _ComparisonTable(),
          const SizedBox(height: 24),

          // ── Tip card ──────────────────────────────────────────────────
          const _TipCard(
            tip: 'Extract the video ID from the URL — it is the value after '
                '"v=" in the query string. Never pass the full YouTube URL '
                'to the controller. Use controller.close() not dispose() '
                'to release the WebView resources.',
          ),
        ],
      ),
    );
  }
}

// ── Data ──────────────────────────────────────────────────────────────────────

class _YtVideo {
  final String id;
  final String title;
  const _YtVideo(this.id, this.title);
}

// ── Comparison table ──────────────────────────────────────────────────────────

class _ComparisonTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
      },
      children: [
        _headerRow(),
        _row('Source', 'Any direct URL\n(MP4, HLS…)', 'YouTube only'),
        _row('Package', 'video_player', 'youtube_player_iframe'),
        _row('Renderer', 'Native codec', 'WebView / IFrame'),
        _row('DRM support', '❌ No', '✅ Yes'),
        _row('Offline', '✅ Local files', '❌ Needs internet'),
        _row('Custom UI', '✅ Full control', '⚠️ Limited'),
        _row('Platform', 'All', 'Android / iOS / Web'),
      ],
    );
  }

  TableRow _headerRow() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      children: ['Feature', 'video_player', 'youtube_player_iframe']
          .map((h) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text(h,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ))
          .toList(),
    );
  }

  TableRow _row(String feature, String a, String b) {
    return TableRow(
      children: [feature, a, b]
          .map((text) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text(text, style: const TextStyle(fontSize: 12)),
              ))
          .toList(),
    );
  }
}

// ── Shared private widgets ────────────────────────────────────────────────────

class _CodeSection extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String code;

  const _CodeSection({
    required this.label,
    required this.labelColor,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: labelColor, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          Text(code,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.5)),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String tip;
  const _TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple),
            const SizedBox(width: 12),
            Expanded(
                child:
                    Text(tip, style: const TextStyle(fontSize: 14, height: 1.5))),
          ],
        ),
      ),
    );
  }
}
