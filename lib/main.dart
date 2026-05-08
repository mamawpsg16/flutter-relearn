import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_relearn/screens/adaptive/adaptive_home.dart';
import 'package:flutter_relearn/screens/navigation/hands_on_screen.dart';
import 'package:flutter_relearn/l10n/app_localizations.dart';

void main() async {
  // Make sure Flutter engine ready
  WidgetsFlutterBinding.ensureInitialized();
  // Make sure Firebase ready and connected
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AdaptiveHome(),
      routes: {
        '/first': (ctx) => const HandsOnScreen(),
        '/second': (ctx) => const SecondScreen(),
      },
    ),
  );
}
