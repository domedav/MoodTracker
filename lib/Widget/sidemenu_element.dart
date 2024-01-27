import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SidemenuElement extends StatelessWidget{
  final String text;
  final IconData icon;
  final VoidCallback? onPress;
  const SidemenuElement({super.key, required this.text, required this.icon, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Container(
        padding: const EdgeInsets.all(7),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: Icon(
                icon,
                color: onPress == null ? Colors.white.withOpacity(.4) : Colors.white,
                size: 20,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                text,
                style: TextStyle(
                  color: onPress == null ? Colors.white.withOpacity(.4) : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}