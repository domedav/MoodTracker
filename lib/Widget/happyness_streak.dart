import 'package:flutter/cupertino.dart';
import 'package:moodtracker/Misc/emojirich_text.dart';

class HappyStreakWidget extends StatelessWidget{
  final int happyStreak;
  const HappyStreakWidget({super.key, required this.happyStreak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: EmojiRichText(
                text: '🔥 Happiness Streak: $happyStreak days 🔥',
                defaultStyle: const TextStyle(
                  color: Color.fromRGBO(0xBF, 0xA4, 0x8A, 1.0),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0,
                ),
                emojiStyle: const TextStyle(
                    color: Color.fromRGBO(0xBF, 0xA4, 0x8A, 1.0),
                    fontSize: 14.0,
                    fontFamily: "Noto Color Emoji"
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}