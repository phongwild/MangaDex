import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get demo1 => 'Đây là Demo1';

  @override
  String get makingAnAdvancePayment => 'Bạn đang ứng tiền trên';

  @override
  String get advanceSubAccount => 'Chọn tiểu khoản ứng';

  @override
  String get moneyCanBeAdvanced => 'Tiền bán có thể ứng';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get amountVND => 'số tiền (VND)';

  @override
  String get howMuch => 'là bao nhiêu?';
}
