import 'package:flutter/cupertino.dart';

class DisplayTextFormatting{
  static String yearToText(int year){
    final chars = year.toString().characters.toList().reversed.toList();
    return "'${chars[1]}${chars[0]}";
  }

  static String monthToText(int month){
    switch (month){
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Okt';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'Invalid Month';
    }
  }

  static String monthToTextFullName(int month){
    switch (month){
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'Septermber';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Invalid Month';
    }
  }
}