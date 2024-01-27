import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:moodtracker/Misc/notifications.dart';

import '../Misc/mood_class.dart';
import 'package:image/image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ExportMoodsToImage{
  static Future<void> export(List<Mood> moods, VoidCallback doAfterDeed)async{
    setup();

    final ByteData data = await rootBundle.load('assets/exportbase.png');
    List<int> bytes = data.buffer.asUint8List();
    Image baseImage = decodeImage(Uint8List.fromList(bytes))!;

    Image clonedImage = copyResize(baseImage, width: baseImage.width, height: baseImage.height);
    for(var item in moods){
      final cR = dayToColumnAndRow(item.time.day);
      colorBlock(item.time.month, cR[0], cR[1], clonedImage, item.value);
    }

    if(Platform.isAndroid){
      await ImageGallerySaver.saveImage(Uint8List.fromList(encodePng(clonedImage)), quality: 100, name: '${moods[0].time.year}_MoodTracker_Summary');
    }
    else if(Platform.isLinux){
      Uint8List pngBytes = Uint8List.fromList(encodePng(clonedImage));
      String filePath = '/home/linux/Pictures/MoodTracker.png';

      File file = File(filePath);
      await file.writeAsBytes(pngBytes);
    }

    await AppNotifications.showNotificationInstant('Image Saved!', 'Your image has been exported to gallery!');
    doAfterDeed();
  }
  
  static List<MonthGridHelper> monthsGrid = <MonthGridHelper>[].toList();
  static List<int> colors = <int>[].toList();
  static const int lineSize = 12;
  static const int emptySpaceSize = 24;
  
  static void setup(){
    monthsGrid.add(const MonthGridHelper(68, 260, 337, 456));     // Jan
    monthsGrid.add(const MonthGridHelper(378, 260, 647, 456));    // Feb
    monthsGrid.add(const MonthGridHelper(688, 260, 957, 456));    // Mar

    monthsGrid.add(const MonthGridHelper(68, 620, 337, 815));     // Apr
    monthsGrid.add(const MonthGridHelper(378, 620, 647, 815));    // May
    monthsGrid.add(const MonthGridHelper(688, 620, 957, 815));    // Jun

    monthsGrid.add(const MonthGridHelper(68, 980, 337, 1174));    // Jul
    monthsGrid.add(const MonthGridHelper(378, 980, 647, 1174));   // Aug
    monthsGrid.add(const MonthGridHelper(688, 980, 957, 1174));   // Sep

    monthsGrid.add(const MonthGridHelper(68, 1340, 337, 1533));   // Okt
    monthsGrid.add(const MonthGridHelper(378, 1340, 647, 1533));  // Nov
    monthsGrid.add(const MonthGridHelper(688, 1340, 957, 1533));  // Dec

    colors.add(getColor(255, 0, 0));    // mood 0
    colors.add(getColor(255, 136, 0));  // mood 1
    colors.add(getColor(255, 244, 0));  // mood 2
    colors.add(getColor(185, 255, 0));  // mood 3
    colors.add(getColor(29, 255, 0));   // mood 4
  }

  static void colorBlock(int month, int column, int row, Image img, int mood){
    final monthHelper = monthsGrid[month - 1];
    final startX = lineSize + monthHelper.startX + column * (lineSize + emptySpaceSize) + column;
    final endX = startX + emptySpaceSize;
    final startY = lineSize + monthHelper.startY + row * (lineSize + emptySpaceSize) + row;
    final endY = startY + emptySpaceSize;
    final color = colors[mood];

    for(int i = startX; i <= endX; i++){
      for(int j = startY; j <= endY; j++){
        img.setPixel(i, j, color);
      }
    }
  }
  
  static List<int> dayToColumnAndRow(int day){
    List<int> columnrow = <int>[].toList();
    int row = ((day - 1) / MonthGridHelper.columnCount).floor();
    int column = ((day - 1) % MonthGridHelper.columnCount).floor();
    columnrow.add(column);
    columnrow.add(row);
    return columnrow;
  }
}

class MonthGridHelper{
  final int startX;
  final int startY;
  final int endX;
  final int endY;
  static const int columnCount = 7;
  static const int rowCount = 5;
  const MonthGridHelper(this.startX, this.startY, this.endX, this.endY);
}