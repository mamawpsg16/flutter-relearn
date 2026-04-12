// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'フラッターリラーン';

  @override
  String get welcomeMessage => 'ストアへようこそ！';

  @override
  String greeting(String name) {
    return 'こんにちは、$nameさん！';
  }

  @override
  String get addToCart => 'カートに追加';

  @override
  String get checkout => 'チェックアウト';

  @override
  String price(String amount) {
    return '価格：$amount';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のアイテム',
      zero: 'アイテムなし',
    );
    return '$_temp0';
  }

  @override
  String get languageName => '日本語';
}
