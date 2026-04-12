// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'فلاتر ريلرن';

  @override
  String get welcomeMessage => 'مرحباً بك في متجرنا!';

  @override
  String greeting(String name) {
    return 'مرحباً، $name!';
  }

  @override
  String get addToCart => 'أضف إلى السلة';

  @override
  String get checkout => 'الدفع';

  @override
  String price(String amount) {
    return 'السعر: $amount';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: 'لا توجد عناصر',
    );
    return '$_temp0';
  }

  @override
  String get languageName => 'العربية';
}
