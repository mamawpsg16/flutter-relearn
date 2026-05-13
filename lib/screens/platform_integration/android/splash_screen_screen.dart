import 'package:flutter/material.dart';

class SplashScreenScreen extends StatelessWidget {
  const SplashScreenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splash Screen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'A splash screen (launch screen) is shown by Android while your app '
              'initialises — before Flutter even starts. It gives users immediate '
              'visual feedback instead of a blank white screen.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            // ── Launch flow diagram ──────────────────────────────────────
            const Text(
              'Launch Flow',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildLaunchFlow(),
            const SizedBox(height: 24),

            // ── Two options ──────────────────────────────────────────────
            const Text(
              'Two Ways to Implement',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildOptionsTable(),
            const SizedBox(height: 24),

            // ── Step 1: styles.xml ────────────────────────────────────────
            const Text(
              'Step 1 — Edit styles.xml',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'android/app/src/main/res/values/styles.xml',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Define a LaunchTheme whose background is your splash drawable, '
              'and a NormalTheme to switch to once Flutter is ready.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'styles.xml — LaunchTheme + NormalTheme',
              labelColor: Colors.green,
              code: '''<resources>
    <!-- Shown while app initialises (before Flutter starts) -->
    <style name="LaunchTheme"
           parent="@android:style/Theme.Black.NoTitleBar">
        <!-- Points to your splash drawable in res/drawable/ -->
        <item name="android:windowBackground">
            @drawable/launch_background
        </item>
    </style>

    <!-- Applied to FlutterActivity after splash disappears -->
    <!-- Use a colour close to your app's background to avoid flash -->
    <style name="NormalTheme"
           parent="@android:style/Theme.Black.NoTitleBar">
        <item name="android:windowBackground">
            @drawable/normal_background
        </item>
    </style>
</resources>''',
            ),
            const SizedBox(height: 24),

            // ── Step 2: AndroidManifest.xml ───────────────────────────────
            const Text(
              'Step 2 — Edit AndroidManifest.xml',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'android/app/src/main/AndroidManifest.xml',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Set the activity theme to LaunchTheme, then add a metadata tag '
              'so Flutter knows when to switch to NormalTheme.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'AndroidManifest.xml — wire LaunchTheme to FlutterActivity',
              labelColor: Colors.green,
              code: '''<activity
    android:name=".MainActivity"
    android:theme="@style/LaunchTheme"
    android:configChanges="..."
    android:hardwareAccelerated="true"
    android:windowSoftInputMode="adjustResize">

    <!-- Tells Flutter: switch to NormalTheme when ready -->
    <meta-data
        android:name=
          "io.flutter.embedding.android.NormalTheme"
        android:resource="@style/NormalTheme" />

    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name=
          "android.intent.category.LAUNCHER"/>
    </intent-filter>
</activity>''',
            ),
            const SizedBox(height: 24),

            // ── Android 12+ SplashScreen API ──────────────────────────────
            const Text(
              'Android 12+ — SplashScreen API',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Android 12 introduced a new SplashScreen API with different '
              'XML attributes. If your app supports both pre-12 and post-12, '
              'use two separate styles.xml files.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'android/app/src/main/res/values-v31/styles.xml (Android 12+)',
              labelColor: Colors.blue,
              code: '''<resources>
    <style name="LaunchTheme"
           parent="@android:style/Theme.Black.NoTitleBar">
        <!-- New API: background colour for the splash -->
        <item name="android:windowSplashScreenBackground">
            @color/bgColor
        </item>
        <!-- New API: animated icon (must follow icon guidelines) -->
        <item name="android:windowSplashScreenAnimatedIcon">
            @drawable/launch_background
        </item>
    </style>
</resources>

<!-- Keep the original styles.xml for Android < 12 -->
<!-- android/app/src/main/res/values/styles.xml stays unchanged -->''',
            ),
            const SizedBox(height: 24),

            // ── MainActivity.kt — keep splash visible ─────────────────────
            const Text(
              'Optional — Keep Splash Visible During Dart Init',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'By default the Android splash fades out before Flutter\'s first '
              'frame renders, causing a brief flicker. Override MainActivity.kt '
              'to remove the fade-out animation so Flutter takes over seamlessly.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'android/app/src/main/kotlin/.../MainActivity.kt',
              labelColor: Colors.blue,
              code: '''import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    // Align Flutter view with the full window (edge-to-edge)
    WindowCompat.setDecorFitsSystemWindows(window, false)

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
      // Android 12+: remove the fade-out animation
      // so there's no flicker before Flutter draws its first frame
      splashScreen.setOnExitAnimationListener { view ->
        view.remove() // remove immediately — Flutter takes over
      }
    }

    super.onCreate(savedInstanceState)
  }
}''',
            ),
            const SizedBox(height: 24),

            // ── launch_background.xml ─────────────────────────────────────
            const Text(
              'The Splash Drawable',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The default Flutter project includes a launch_background.xml '
              'drawable you can customise. It\'s a layer-list — you can add '
              'your logo on top of a background colour.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'android/app/src/main/res/drawable/launch_background.xml',
              labelColor: Colors.orange,
              code: '''<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Background colour -->
    <item android:drawable="@android:color/white" />

    <!-- Centred logo (optional) -->
    <item>
        <bitmap
            android:gravity="center"
            android:src="@mipmap/ic_launcher" />
    </item>
</layer-list>''',
            ),
            const SizedBox(height: 24),

            // ── Visual summary ─────────────────────────────────────────────
            const Text(
              'File Checklist',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildChecklist(),
            const SizedBox(height: 24),

            const _TipCard(
              tip:
                  'The NormalTheme background colour matters — it\'s briefly '
                  'visible during orientation changes and activity restoration. '
                  'Set it to match your app\'s primary background colour '
                  '(usually white or your scaffold background) to avoid a flash.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaunchFlow() {
    final steps = [
      _FlowStep(
        icon: Icons.android,
        color: Colors.green,
        label: 'Android OS',
        sublabel: 'App process starts',
      ),
      _FlowStep(
        icon: Icons.image_outlined,
        color: Colors.blue,
        label: 'LaunchTheme',
        sublabel: 'Splash drawable shown\n(styles.xml)',
      ),
      _FlowStep(
        icon: Icons.settings,
        color: Colors.orange,
        label: 'Flutter engine',
        sublabel: 'Engine initialises\nDart VM starts',
      ),
      _FlowStep(
        icon: Icons.phone_android,
        color: Colors.purple,
        label: 'NormalTheme',
        sublabel: 'Flutter draws\nfirst frame',
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: steps.map((step) {
          final isLast = step == steps.last;
          return Row(
            children: [
              _FlowStepWidget(step: step),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOptionsTable() {
    const h = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    const c = TextStyle(fontSize: 12);

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: const [
            Padding(padding: EdgeInsets.all(8), child: Text('Option', style: h)),
            Padding(padding: EdgeInsets.all(8), child: Text('How', style: h)),
            Padding(padding: EdgeInsets.all(8), child: Text('Best for', style: h)),
          ],
        ),
        TableRow(children: [
          const Padding(padding: EdgeInsets.all(8), child: Text('Package', style: c)),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text('flutter_native_splash\nor flutter_splash_screen',
                  style: c)),
          const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Quick setup, most apps', style: c)),
        ]),
        TableRow(children: [
          const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Manual', style: c)),
          const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Edit styles.xml +\nAndroidManifest.xml', style: c)),
          const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Full control, custom animations', style: c)),
        ]),
      ],
    );
  }

  Widget _buildChecklist() {
    final files = [
      _CheckItem(
        file: 'res/drawable/launch_background.xml',
        description: 'Your splash graphic (layer-list with colour + logo)',
        color: Colors.orange,
      ),
      _CheckItem(
        file: 'res/values/styles.xml',
        description: 'LaunchTheme + NormalTheme definitions',
        color: Colors.blue,
      ),
      _CheckItem(
        file: 'res/values-v31/styles.xml',
        description: 'Android 12+ SplashScreen API overrides (if needed)',
        color: Colors.blue,
      ),
      _CheckItem(
        file: 'AndroidManifest.xml',
        description: 'Set android:theme + NormalTheme meta-data on activity',
        color: Colors.green,
      ),
      _CheckItem(
        file: 'MainActivity.kt (optional)',
        description: 'Remove fade-out animation to prevent flicker on Android 12+',
        color: Colors.purple,
      ),
    ];

    return Column(
      children: files
          .map((item) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(color: item.color, width: 3)),
                  color: item.color.withValues(alpha: 0.05),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: item.color, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.file,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item.description,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _FlowStep {
  final IconData icon;
  final Color color;
  final String label;
  final String sublabel;
  const _FlowStep({
    required this.icon,
    required this.color,
    required this.label,
    required this.sublabel,
  });
}

class _FlowStepWidget extends StatelessWidget {
  final _FlowStep step;
  const _FlowStepWidget({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: step.color.withValues(alpha: 0.1),
        border: Border.all(color: step.color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(step.icon, color: step.color, size: 28),
          const SizedBox(height: 6),
          Text(
            step.label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: step.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            step.sublabel,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CheckItem {
  final String file;
  final String description;
  final Color color;
  const _CheckItem({
    required this.file,
    required this.description,
    required this.color,
  });
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            code,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 12,
              height: 1.5,
            ),
          ),
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
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple),
            const SizedBox(width: 8),
            Expanded(child: Text(tip, style: const TextStyle(height: 1.5))),
          ],
        ),
      ),
    );
  }
}
