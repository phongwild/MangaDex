import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'color_theme/color_define.dart';
import 'color_theme/color_key.dart';
import 'color_theme/map_color_dark.dart';
import 'color_theme/map_color_light.dart';

class AppColors {
  static Color get bgMain => colorApp(ColorKey.bgMain);
  static Color get primary => colorApp(ColorKey.primary);
  static Color get primary16 => colorApp(ColorKey.primary16);
  static Color get primaryDark => colorApp(ColorKey.primaryDark);
  static Color get primaryLight => colorApp(ColorKey.primaryLight);
  static Color get primaryChartLight => colorApp(ColorKey.primaryChartLight);
  static Color get red => colorApp(ColorKey.red);
  static Color get redDark => colorApp(ColorKey.redDark);
  static Color get redLight => colorApp(ColorKey.redLight);
  static Color get red16 => colorApp(ColorKey.red16);
  static Color get yellow => colorApp(ColorKey.yellow);
  static Color get yellowLight => colorApp(ColorKey.yellowLight);
  static Color get yellowDark => colorApp(ColorKey.yellowDark);
  static Color get yellow16 => colorApp(ColorKey.yellow16);
  static Color get yellowChartLight => colorApp(ColorKey.yellowChartLight);
  static Color get purple => colorApp(ColorKey.purple);
  static Color get purpleLight => colorApp(ColorKey.purpleLight);
  static Color get purpleDark => colorApp(ColorKey.purpleDark);
  static Color get purple16 => colorApp(ColorKey.purple16);
  static Color get purpleChartLight => colorApp(ColorKey.purpleChartLight);
  static Color get blue => colorApp(ColorKey.blue);
  static Color get blueLight => colorApp(ColorKey.blueLight);
  static Color get blueDark => colorApp(ColorKey.blueDark);
  static Color get blue16 => colorApp(ColorKey.blue16);
  static Color get highlightBg => colorApp(ColorKey.hightLightBg);
  static Color get black => colorApp(ColorKey.black);
  static Color get gray900 => colorApp(ColorKey.gray900);
  static Color get gray700 => colorApp(ColorKey.gray700);
  static Color get gray500 => colorApp(ColorKey.gray500);
  static Color get gray300 => colorApp(ColorKey.gray300);
  static Color get gray100 => colorApp(ColorKey.gray100);
  static Color get white => colorApp(ColorKey.white);
  static Color get skeletonBase => colorApp(ColorKey.skeletonBase);
  static Color get skeletonHighLight => colorApp(ColorKey.skeletonHighLight);
  static Color get blueChart => colorApp(ColorKey.blueChart);
  static Color get blueChartLight => colorApp(ColorKey.blueChartLight);
  static Color get bgPopup => colorApp(ColorKey.bgPopup);
  static Color get highlightPopup => colorApp(ColorKey.highlightPopup);
  static Color get bgLoading => colorApp(ColorKey.bgLoading);
  static Color get colorIcon => colorApp(ColorKey.colorIcon);
  static Color get bgBottomBar => colorApp(ColorKey.bgBottomBar);
  static Color get buttonEnableBg => colorApp(ColorKey.buttonEnableBg);
  static Color get buttonDisableBg => colorApp(ColorKey.buttonDisableBg);
  static Color get buttonEnablePopup => colorApp(ColorKey.buttonEnablePopup);
  static Color get buttonDisablePopup => colorApp(ColorKey.buttonDisablePopup);
  static Color get divider => colorApp(ColorKey.divider);
  static Color get borderBg => colorApp(ColorKey.borderBg);
  static Color get borderPopUp => colorApp(ColorKey.borderPopUp);
  static Color get referenceColor => colorApp(ColorKey.referenceColor);
  static Color get decreaseColor => colorApp(ColorKey.decreaseColor);
  static Color get increaseColor => colorApp(ColorKey.increaseColor);
  static Color get floorColor => colorApp(ColorKey.floorColor);
  static Color get ceilingColor => colorApp(ColorKey.ceilingColor);
  static Color get text => colorApp(ColorKey.text);
  static Color get text900 => colorApp(ColorKey.text900);
  static Color get text700 => colorApp(ColorKey.text700);
  static Color get text500 => colorApp(ColorKey.text500);
  static Color get cursorTextField => colorApp(ColorKey.cursorTextField);
  static Color get bgSnackBar => colorApp(ColorKey.bgSnackBar);
  static Color get overlayBottomSheet => colorApp(ColorKey.overlayBottomSheet);
  static Color get textEnable => colorApp(ColorKey.textEnable);
  static const transparent = ColorDefine.transparent;
}

Map<String, Map<String, Color>> _themeColor = {
  TypeTheme.light.name: mapColorLight,
  // TypeTheme.dark.name: mapColorDark
};

Color colorApp(String keyValue) {
  return _themeColor[AppTheme().type.name]?[keyValue] ?? Colors.white;
}
