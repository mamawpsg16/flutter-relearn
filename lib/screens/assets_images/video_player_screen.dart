import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  // ✅ Store the Future — this is the official Flutter docs pattern
  late Future<void> _initializeVideoPlayerFuture;

  // bee.mp4 — lower resolution, simpler H.264 profile, more compatible
  static const _videoUrl =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(_videoUrl));

    // Store the Future — do NOT await it here.
    // FutureBuilder will listen to it and rebuild when done.
    _initializeVideoPlayerFuture = _controller.initialize();

    // addListener keeps the progress bar / play button in sync
    _controller.addListener(() {
      if (mounted) setState(() {});
    });

    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play & Pause a Video'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Concept explanation ──────────────────────────────────────
          const Text(
            'Flutter has no built-in video widget — use the video_player '
            'package. Create a VideoPlayerController, store the Future from '
            'initialize(), then hand that Future to a FutureBuilder so the '
            'UI shows a spinner while loading and the video once ready.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),

          // ── BAD code ─────────────────────────────────────────────────
          const _CodeSection(
            label: 'BAD — awaiting initialize() & forgetting dispose()',
            labelColor: Colors.red,
            code: '''class _MyState extends State<MyWidget> {
  late VideoPlayerController _ctrl;

  @override
  void initState() {
    super.initState();
    // ❌ You cannot await in initState — this silently fails
    await _ctrl.initialize();
  }

  // ❌ No dispose() — leaks memory and network connections
}''',
          ),
          const SizedBox(height: 12),

          // ── GOOD code ────────────────────────────────────────────────
          const _CodeSection(
            label: 'GOOD — store the Future, use FutureBuilder, dispose',
            labelColor: Colors.green,
            code: '''class _MyState extends State<MyWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initFuture;   // ✅ store the Future

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _initFuture = _controller.initialize(); // ✅ don't await
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();  // ✅ always release resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,   // ✅ FutureBuilder handles loading state
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

// Play / Pause toggle:
setState(() {
  _controller.value.isPlaying
    ? _controller.pause()
    : _controller.play();
});''',
          ),
          const SizedBox(height: 24),

          // ── Live demo ─────────────────────────────────────────────────
          const Text(
            'Live Demo — Butterfly (official Flutter docs video)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // FutureBuilder — exactly the official Flutter docs pattern
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return _ErrorCard(error: snapshot.error.toString());
                }
                return _VideoControls(
                  controller: _controller,
                  fmt: _fmt,
                );
              }
              return _LoadingCard();
            },
          ),
          const SizedBox(height: 24),

          // ── Key API reference ─────────────────────────────────────────
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Key VideoPlayerController APIs',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _ApiRow('.initialize()', 'Returns Future — store it for FutureBuilder'),
                  _ApiRow('.play()', 'Starts playback'),
                  _ApiRow('.pause()', 'Pauses playback'),
                  _ApiRow('.setLooping(true)', 'Loop the video'),
                  _ApiRow('.seekTo(Duration)', 'Jump to a position'),
                  _ApiRow('.dispose()', 'Release resources — call in dispose()'),
                  _ApiRow('.value.isPlaying', 'True while playing'),
                  _ApiRow('.value.position', 'Current playback position'),
                  _ApiRow('.value.duration', 'Total video duration'),
                  _ApiRow('.value.aspectRatio', 'Video width ÷ height'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Tip card ──────────────────────────────────────────────────
          const _TipCard(
            tip: 'Store the Future from initialize() in a variable and pass '
                'it to FutureBuilder — never await it in initState(). '
                'Use addListener(() => setState((){})) to keep controls '
                'like the seek bar synced as the video plays.',
          ),
        ],
      ),
    );
  }
}

// ── Demo sub-widgets ──────────────────────────────────────────────────────────

class _LoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 12),
            Text('Loading video…', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String error;
  const _ErrorCard({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 40, color: Colors.red),
          const SizedBox(height: 8),
          const Text('Could not load video',
              style:
                  TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _VideoControls extends StatelessWidget {
  final VideoPlayerController controller;
  final String Function(Duration) fmt;

  const _VideoControls({required this.controller, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final position = controller.value.position;
    final duration = controller.value.duration;
    final isPlaying = controller.value.isPlaying;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (v) => controller.seekTo(
              Duration(milliseconds: (v * duration.inMilliseconds).round()),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(fmt(position),
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.replay_10),
              onPressed: () => controller.seekTo(Duration(
                  seconds:
                      (position.inSeconds - 10).clamp(0, duration.inSeconds))),
            ),
            IconButton(
              iconSize: 40,
              icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
              onPressed: () =>
                  isPlaying ? controller.pause() : controller.play(),
            ),
            IconButton(
              icon: const Icon(Icons.forward_10),
              onPressed: () => controller.seekTo(Duration(
                  seconds:
                      (position.inSeconds + 10).clamp(0, duration.inSeconds))),
            ),
            const Spacer(),
            Text(fmt(duration),
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

// ── Shared private widgets ────────────────────────────────────────────────────

class _ApiRow extends StatelessWidget {
  final String api;
  final String desc;

  const _ApiRow(this.api, this.desc);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 155,
            child: Text(api,
                style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
              child: Text(desc, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}

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
                  color: labelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
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
                child: Text(tip,
                    style: const TextStyle(fontSize: 14, height: 1.5))),
          ],
        ),
      ),
    );
  }
}
