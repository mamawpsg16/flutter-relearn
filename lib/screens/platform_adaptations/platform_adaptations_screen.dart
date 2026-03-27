// Flutter auto-adapts some widgets per platform. You can also manually branch with Theme.of(context).platform

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // defaultTargetPlatform
import 'package:flutter/material.dart';

class PlatformAdaptationsScreen extends StatefulWidget {
  const PlatformAdaptationsScreen({super.key});

  @override
  State<PlatformAdaptationsScreen> createState() =>
      _PlatformAdaptationsScreenState();
}

class _PlatformAdaptationsScreenState
    extends State<PlatformAdaptationsScreen> {
  bool _switchValue = true;
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    // ── Detect the current platform ──────────────────────────────────────────
    // Option 1: via Theme (respects overrides in tests/ThemeData)
    final platform = Theme.of(context).platform;
    // Option 2: via foundation (always reflects the real compile-time platform)
    final defaultPlatform = defaultTargetPlatform;

    final isIOS = platform == TargetPlatform.iOS;
    final platformName = _platformName(defaultPlatform);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Adaptations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Platform detection ────────────────────────────────────────
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detecting the platform',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // Show both APIs
                    _CodeRow(
                      label: 'Theme.of(context).platform',
                      value: platform.name,
                    ),
                    _CodeRow(
                      label: 'defaultTargetPlatform',
                      value: defaultPlatform.name,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'You are running on: $platformName',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Switch ────────────────────────────────────────────────────
            _SectionTitle('Switch'),
            const _Tip(
              'Material Switch on Android — rounded thumb.\n'
              'CupertinoSwitch on iOS — pill-shaped, green by default.',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Material:'),
                const SizedBox(width: 8),
                Switch(
                  value: _switchValue,
                  onChanged: (v) => setState(() => _switchValue = v),
                ),
                const SizedBox(width: 24),
                const Text('Cupertino:'),
                const SizedBox(width: 8),
                CupertinoSwitch(
                  value: _switchValue,
                  onChanged: (v) => setState(() => _switchValue = v),
                ),
              ],
            ),
            // Adaptive constructor — Flutter picks the right one automatically
            Row(
              children: [
                const Text('Switch.adaptive:'),
                const SizedBox(width: 8),
                Switch.adaptive(
                  value: _switchValue,
                  onChanged: (v) => setState(() => _switchValue = v),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Slider ────────────────────────────────────────────────────
            _SectionTitle('Slider'),
            const _Tip(
              'Material Slider has a colored track and a circular thumb.\n'
              'CupertinoSlider is thinner. Use Slider.adaptive to auto-pick.',
            ),
            const SizedBox(height: 8),
            const Text('Material:', style: TextStyle(color: Colors.black54)),
            Slider(
              value: _sliderValue,
              onChanged: (v) => setState(() => _sliderValue = v),
            ),
            const Text('Cupertino:', style: TextStyle(color: Colors.black54)),
            CupertinoSlider(
              value: _sliderValue,
              onChanged: (v) => setState(() => _sliderValue = v),
            ),
            const Text('Slider.adaptive:', style: TextStyle(color: Colors.black54)),
            Slider.adaptive(
              value: _sliderValue,
              onChanged: (v) => setState(() => _sliderValue = v),
            ),

            const SizedBox(height: 24),

            // ── Progress indicator ────────────────────────────────────────
            _SectionTitle('Progress Indicator'),
            const _Tip(
              'Material uses a spinning circle.\n'
              'Cupertino uses an activity spinner (8 fading lines).',
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Material', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: const [
                    CupertinoActivityIndicator(),
                    SizedBox(height: 8),
                    Text('Cupertino', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Buttons ───────────────────────────────────────────────────
            _SectionTitle('Buttons'),
            const _Tip(
              'ElevatedButton is Material Design.\n'
              'CupertinoButton has no elevation, uses fill or text style.',
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('ElevatedButton'),
                ),
                CupertinoButton(
                  onPressed: () {},
                  color: CupertinoColors.activeBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('CupertinoButton'),
                ),
                CupertinoButton(
                  onPressed: () {},
                  child: const Text('Cupertino text'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Manual branching example ──────────────────────────────────
            _SectionTitle('Manual platform branching'),
            const _Tip(
              'Use Theme.of(context).platform or defaultTargetPlatform to '
              'render different widgets or behaviour per platform.',
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isIOS ? Colors.grey.shade100 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isIOS ? Colors.grey : Colors.blue,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isIOS ? CupertinoIcons.checkmark_circle : Icons.android,
                    color: isIOS ? Colors.grey : Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      isIOS
                          ? 'iOS detected — showing Cupertino style'
                          : 'Android / other — showing Material style',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Summary ───────────────────────────────────────────────────
            Card(
              color: Colors.green.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key takeaways',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Many widgets have .adaptive() constructors that auto-pick.\n'
                      '• import flutter/cupertino.dart for iOS-style widgets.\n'
                      '• Use Theme.of(context).platform for logic branching.\n'
                      '• Use defaultTargetPlatform from flutter/foundation.dart '
                      'outside of a BuildContext.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _platformName(TargetPlatform p) {
    switch (p) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.linux:
        return 'Linux';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
    }
  }
}

// ── Helper widgets ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

class _Tip extends StatelessWidget {
  final String text;
  const _Tip(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Colors.black54, fontSize: 12));
  }
}

class _CodeRow extends StatelessWidget {
  final String label;
  final String value;
  const _CodeRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Flexible(
            child: Text(
              '$label → ',
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
