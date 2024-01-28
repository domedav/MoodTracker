import 'dart:developer';
import 'dart:io';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
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

  static tz.TZDateTime _convert(int hour, int minutes){
    final now = tz.TZDateTime.now(tz.local);
    var scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
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
      tz.initializeTimeZones();
      final String timeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZone));

      await _localnotifs.zonedSchedule(
          0,
          title,
          content,
          _convert(19, 0),
          details,
          androidAllowWhileIdle: true,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
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