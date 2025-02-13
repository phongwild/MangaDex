import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get demo1 => 'This is Demo1';

  @override
  String get makingAnAdvancePayment => 'You are making an advance payment';

  @override
  String get advanceSubAccount => 'Select advance sub-account';

  @override
  String get moneyCanBeAdvanced => 'Sale money can be advanced';

  @override
  String get confirm => 'Confirm';

  @override
  String get amountVND => 'amount (VND)';

  @override
  String get howMuch => 'How much is it?';
}
