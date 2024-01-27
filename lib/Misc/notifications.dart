import 'dart:developer';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotifications{
  static final FlutterLocalNotificationsPlugin _localnotifs = FlutterLocalNotificationsPlugin();
  static Future<void> setup()async{
    if(Platform.isAndroid){
      AndroidFlutterLocalNotificationsPlugin().requestExactAlarmsPermission();
      _localnotifs.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    }
    await _localnotifs.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      linux: LinuxInitializationSettings(
        defaultActionName: 'Dismiss'
      )
    ));
  }

  static Future<void> showNotification() async{
    await _localnotifs.cancel(0);
    const title = 'Whats your mood?';
    const content = 'How do you feel today?';
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
          '0',
          'MoodTracker',
          channelDescription: 'MoodTracker',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'MoodTracker'
      ),
      linux: LinuxNotificationDetails(
        defaultActionName: 'Dismiss',
        urgency: LinuxNotificationUrgency.normal,
      ),
    );
    if(Platform.isAndroid){
      await _localnotifs.periodicallyShow(0, title, content, RepeatInterval.daily, details, androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
    }
  }

  static Future<void> showNotificationInstant(String title, String desc,) async{
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
          '0',
          'MoodTracker',
          channelDescription: 'MoodTracker',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'MoodTracker'
      ),
      linux: LinuxNotificationDetails(
        defaultActionName: 'Dismiss',
        urgency: LinuxNotificationUrgency.normal,
      ),
    );
    _localnotifs.show(0, title, desc, details);
  }
}