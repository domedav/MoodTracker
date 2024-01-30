import 'package:flutter/material.dart';

class AppTheme{
  static int themingKey = 0;
  static const ThemeContainer darkTheme = ThemeContainer(
      background: Color.fromRGBO(22, 22, 22, 1.0),
      text: Colors.white,
      primary: Color.fromRGBO(42, 42, 42, 1.0),
      secondary: Color.fromRGBO(0xBF, 0xA4, 0x8A, 1.0),
      moodColor_1: Colors.red,
      moodColor_2: Colors.orange,
      moodColor_3: Colors.yellow,
      moodColor_4: Colors.greenAccent,
      moodColor_5: Colors.green,
      isDark: true,
  );

  static const ThemeContainer lightTheme = ThemeContainer(
      background: Color.fromRGBO(0xFF, 0xE9, 0xDC, 1.0),
      text: Colors.black,
      primary: Color.fromRGBO(0xFF, 0xF1, 0xE3, 1.0),
      secondary: Color.fromRGBO(0x87, 0x67, 0x31, 1),
      moodColor_1: Color.fromRGBO(0xB9, 0x36, 0x36, 1.0),
      moodColor_2: Color.fromRGBO(0xB9, 0x6F, 0x36, 1.0),
      moodColor_3: Color.fromRGBO(0xB9, 0xB2, 0x36, 1.0),
      moodColor_4: Color.fromRGBO(0x36, 0xB9, 0x59, 1.0),
      moodColor_5: Color.fromRGBO(0x68, 0xB9, 0x36, 1.0),
      isDark: false
  );

  static const ThemeContainer vampireTheme = ThemeContainer(
    background: Color.fromRGBO(10, 10, 10, 1.0),
    text: Color.fromRGBO(228, 228, 228, 1.0),
    primary: Color.fromRGBO(22, 22, 22, 1.0),
    secondary: Color.fromRGBO(0x87, 0x74, 0x61, 1.0),
    moodColor_1: Color.fromRGBO(211, 158, 158, 1.0),
    moodColor_2: Color.fromRGBO(213, 182, 153, 1.0),
    moodColor_3: Color.fromRGBO(224, 212, 169, 1.0),
    moodColor_4: Color.fromRGBO(161, 213, 191, 1.0),
    moodColor_5: Color.fromRGBO(183, 217, 173, 1.0),
    isDark: true,
  );

  static const ThemeContainer pinkTheme = ThemeContainer(
      background: Color.fromRGBO(0xE1, 0xCC, 0xF5, 1.0),
      text: Color.fromRGBO(48, 0, 42, 1.0),
      primary: Color.fromRGBO(0xD4, 0xB4, 0xEB, 1.0),
      secondary: Color.fromRGBO(0x57, 0x0, 0x4E, 1.0),
      moodColor_1: Color.fromRGBO(0x90, 0x1D, 0x4C, 1.0),
      moodColor_2: Color.fromRGBO(0x8C, 0x1F, 0x74, 1.0),
      moodColor_3: Color.fromRGBO(0x6B, 0x18, 0x86, 1.0),
      moodColor_4: Color.fromRGBO(0x4D, 0x22, 0x80, 1.0),
      moodColor_5: Color.fromRGBO(0x37, 0x27, 0x86, 1.0),
      isDark: false
  );

  static const ThemeContainer treasuremapTheme = ThemeContainer(
      background: Color.fromRGBO(0xF5, 0xDC, 0xC5, 1.0),
      text: Color.fromRGBO(59, 42, 42, 1.0),
      primary: Color.fromRGBO(0xEB, 0xC8, 0xAD, 1.0),
      secondary: Color.fromRGBO(0x3A, 0x3A, 0x3A, 1.0),
      moodColor_1: Color.fromRGBO(156, 74, 74, 1.0),
      moodColor_2: Color.fromRGBO(164, 65, 65, 1.0),
      moodColor_3: Color.fromRGBO(161, 42, 42, 1.0),
      moodColor_4: Color.fromRGBO(165, 23, 23, 1.0),
      moodColor_5: Color.fromRGBO(155, 1, 1, 1.0),
      isDark: false
  );

  static ThemeContainer getCurrentTheme(BuildContext context){
    switch (themingKey){
      case 1:
        return darkTheme;
      case 2:
        return lightTheme;
      case 3:
        return vampireTheme;
      case 4:
        return pinkTheme;
      case 5:
        return treasuremapTheme;
      default: // use system default
        final isDarkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
        if (isDarkTheme) {
          return darkTheme;
        }
        return lightTheme;
    }
  }
}

class ThemeContainer{
  final Color background;
  final Color text;
  final Color primary;
  final Color secondary;
  final bool isDark;

  final Color moodColor_5;
  final Color moodColor_4;
  final Color moodColor_3;
  final Color moodColor_2;
  final Color moodColor_1;

  const ThemeContainer({required this.background, required this.text, required this.primary, required this.secondary, required this.isDark, required this.moodColor_1, required this.moodColor_2, required this.moodColor_3, required this.moodColor_4, required this.moodColor_5});
}