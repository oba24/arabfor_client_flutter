import 'package:flutter/material.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'extintions.dart';

class StylesApp {
  static Color primary = "#EAE6D9".toColor;
  static Color secondary = "#43290A".toColor;
  static Color surface = "#F8F9FC".toColor;
  static Color primaryContainer = "#FBF9F4".toColor;
  static Color secondaryContainer = "#F7F5EF".toColor;
  static Color tertiary = "#958A7E".toColor;
  static TextTheme textTheme() => TextTheme(
        headline6: TextStyle(fontFamily: 'Somar', fontSize: 16.0, color: secondary, fontWeight: FontWeight.w700),
        headline4: TextStyle(fontFamily: 'Somar', fontSize: 20.0, color: secondary, fontWeight: FontWeight.w700, height: 1.0),
        headline3: TextStyle(fontFamily: 'Somar', fontSize: 22.0, color: secondary, fontWeight: FontWeight.w700, height: 1.1),
        headline2: TextStyle(fontFamily: 'Somar', fontSize: 33.0, color: secondary, letterSpacing: -0.528, fontWeight: FontWeight.w700, height: 1.52),
        headline1: TextStyle(fontFamily: 'Somar', fontSize: 40.0, fontWeight: FontWeight.w700, color: secondary, height: 1),
        headline5: TextStyle(fontFamily: 'Somar', fontSize: 18.0, fontWeight: FontWeight.w700, color: secondary, height: 1),
        subtitle2: const TextStyle(fontFamily: 'Somar', fontSize: 14.0, color: Color(0xFF958A7E), fontWeight: FontWeight.w500, height: 1),
        subtitle1: const TextStyle(fontFamily: 'Somar', fontSize: 18.0, color: Color(0xFF958A7E), fontWeight: FontWeight.w500, height: 1.11),
        bodyText2: TextStyle(fontFamily: 'Somar', fontSize: 18.0, color: secondary, fontWeight: FontWeight.w600, height: 1.5),
        bodyText1: TextStyle(fontFamily: 'Somar', fontSize: 18.0, color: secondary, fontWeight: FontWeight.w500, height: 1.5),
        caption: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, height: 1.2),
      );
  static ThemeData getLightTheme() {
    return ThemeData(
      platform: TargetPlatform.iOS,
      primaryColor: Colors.white,
      brightness: Brightness.light,
      // dividerColor: Ui.parseColor(setting.value.accentColor, opacity: 0.1),
      // focusColor: Ui.parseColor(setting.value.accentColor),
      // hintColor: Ui.parseColor(setting.value.secondColor),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: primary)),
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        primaryContainer: primaryContainer,
        tertiary: tertiary,
        secondaryContainer: secondaryContainer,
      ),

      iconTheme: IconThemeData(size: 20.px, color: secondary),
      textTheme: textTheme(),
      appBarTheme: AppBarTheme(iconTheme: IconThemeData(size: 20.px, color: secondary)),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: textTheme().bodyText1,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
