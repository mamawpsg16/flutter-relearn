// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appTitle => 'Flutter Relearn';

  @override
  String get welcomeMessage => 'Maligayang pagdating sa aming tindahan!';

  @override
  String greeting(String name) {
    return 'Kamusta, $name!';
  }

  @override
  String get addToCart => 'Idagdag sa Cart';

  @override
  String get checkout => 'Mag-checkout';

  @override
  String price(String amount) {
    return 'Presyo: $amount';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count na aytem',
      one: '1 aytem',
      zero: 'Walang aytem',
    );
    return '$_temp0';
  }

  @override
  String get languageName => 'Filipino';
}
