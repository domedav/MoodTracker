import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Misc/apptheme.dart';

class LineWithTimeWidget extends StatelessWidget{
  final String displayText;
  const LineWithTimeWidget({super.key, required this.displayText});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getCurrentTheme(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: theme.text.withOpacity(.5),
              height: 1,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              displayText,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.text.withOpacity(.5),
                fontWeight: FontWeight.w400,
                fontSize: 12
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: theme.text.withOpacity(.5),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}