import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Misc/apptheme.dart';

class TopMenu extends StatelessWidget{
  const TopMenu({super.key, required this.onMenuPressed, required this.progress});
  final VoidCallback onMenuPressed;
  final Animation<double> progress;
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getCurrentTheme(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 25),
      color: theme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: onMenuPressed,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  foregroundColor: MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  surfaceTintColor: MaterialStateProperty.all(Colors.transparent)
                ),
                child: AnimatedIcon(
                  color: theme.text,
                  size: 30,
                  icon: AnimatedIcons.menu_close,
                  progress: progress,
                )
            )
          ],
        ),
      )
    );
  }
}