import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oxdo_flutter_local_notification/main.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // To show the progress notification
  Future<void> showProgressNotification(int progress, int maxProgress) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "progrees_channel_id",
      "progress_channel",
      channelDescription: "progress_channel_description",
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      progress: progress,
      maxProgress: maxProgress,
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      1,
      "Downloading...",
      "Progress: ${(progress / maxProgress * 100).round()}%",
      notificationDetails,
      payload: 'item x',
    );
  }

  Future<void> _simulateDownload() async {
    int progress = 0;
    int maxProgress = 100;

    while (progress <= maxProgress) {
      await showProgressNotification(progress, maxProgress);
      await Future.delayed(const Duration(seconds: 1));
      progress += 1;
    }

    // Cancel the notification when done
    await flutterLocalNotificationsPlugin.cancel(1);
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // notification id.
      'Test Notification',
      'This is the body of the notification',
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Local notification"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // checking whether permission denied
                if (await Permission.notification.isDenied) {
                  // requesting notificaton permission on run time
                  await Permission.notification.request();
                }
                await _simulateDownload();
              },
              child: const Text("Show Progress Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
