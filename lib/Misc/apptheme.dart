import 'package:flutter/material.dart';

class AppTheme{
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

  static ThemeContainer getCurrentTheme(BuildContext context){
    final isDarkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    if(isDarkTheme){
      return darkTheme;
    }
    return lightTheme;
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