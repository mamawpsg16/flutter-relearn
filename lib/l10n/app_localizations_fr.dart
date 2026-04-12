// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Flutter Relearn';

  @override
  String get welcomeMessage => 'Bienvenue dans notre boutique !';

  @override
  String greeting(String name) {
    return 'Bonjour, $name !';
  }

  @override
  String get addToCart => 'Ajouter au panier';

  @override
  String get checkout => 'Commander';

  @override
  String price(String amount) {
    return 'Prix : $amount';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
      zero: 'Aucun article',
    );
    return '$_temp0';
  }

  @override
  String get languageName => 'Français';
}
