import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodtracker/Misc/formatting.dart';
import 'package:moodtracker/Misc/mood_class.dart';
import 'package:moodtracker/Widget/line_with_time.dart';

class MoodWidget extends StatelessWidget{
  final Mood mood;
  const MoodWidget({super.key, required this.mood});

  Icon getIconFromSatisfication(int val){
    IconData? data;
    Color? col;
    switch (val){
      case 0:
        data = Icons.sentiment_very_dissatisfied_rounded;
        col = Colors.red;
        break;
      case 1:
        data = Icons.sentiment_dissatisfied_rounded;
        col = Colors.orange;
        break;
      case 2:
        data = Icons.sentiment_neutral_rounded;
        col = Colors.yellow;
        break;
      case 3:
        data = Icons.sentiment_satisfied_rounded;
        col = Colors.greenAccent;
        break;
      case 4:
        data = Icons.sentiment_very_satisfied_rounded;
        col = Colors.green;
        break;
    }
    return Icon(
      data!,
      color: col,
      size: 30,
    );
  }

  Color getBackgroundColoring(int val){
    Color? col;
    switch (val){
      case 0:
        col = Colors.red.withOpacity(.06);
        break;
      case 1:
        col = Colors.orange.withOpacity(.06);
        break;
      case 2:
        col = Colors.yellow.withOpacity(.06);
        break;
      case 3:
        col = Colors.greenAccent.withOpacity(.06);
        break;
      case 4:
        col = Colors.green.withOpacity(.06);
        break;
    }
    return col!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: getBackgroundColoring(mood.value),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: getIconFromSatisfication(mood.value)
              ),
              Expanded(
                flex: 4,
                child: Text(
                  '${DisplayTextFormatting.yearToText(mood.time.year)} ${DisplayTextFormatting.monthToText(mood.time.month)} ${mood.time.day}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 24
                  ),
                )
              )
            ],
          ),
          mood.comment.isNotEmpty ? Container(color: Colors.white.withOpacity(.2), height: 1, margin: const EdgeInsets.symmetric(vertical: 10),) : const SizedBox(),
          mood.comment.isNotEmpty ? Container(
            padding: const EdgeInsets.all(6),
            child: Text(
              mood.comment,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white.withOpacity(.6),
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
            ),
          ) : const SizedBox(),
        ],
      ),
    );
  }
}