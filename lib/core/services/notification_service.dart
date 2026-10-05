import 'dart:io';

import 'package:assab/core/services/permission_service.dart';
import 'package:assab/core/utils/app_logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

enum NotificationType { basic, progress, complete }

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _basicChannelId = 'basic_channel';
  static const String _basicChannelName = 'Basic Notifications';
  static const String _basicChannelDesc = 'General app notifications';

  static const String _downloadChannelId = 'download_channel';
  static const String _downloadChannelName = 'Download Notifications';
  static const String _downloadChannelDesc = 'Download progress and completion';

  static const String _completeChannelId = 'complete_channel';
  static const String _completeChannelName = 'Completed Downloads';
  static const String _completeChannelDesc = 'Shown when a download completes';

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        AppLogger.log('Notification tapped: ${response.payload}');
      },
    );

    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await PermissionService.requestPermission(
        permission: Permission.notification,
      );
    } else if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  static Future<void> show({
    required int id,
    required String title,
    required String body,
    required NotificationType type,
    String? payload,
    int progress = 0,
  }) async {
    final details = await _getNotificationDetails(type, progress: progress);

    await _plugin.show(id, title, body, details, payload: payload);
  }

  static Future<void> cancel(int id) async => await _plugin.cancel(id);

  static Future<NotificationDetails> _getNotificationDetails(
    NotificationType type, {
    int progress = 0,
  }) async {
    return switch (type) {
      NotificationType.basic => _basicNotificationDetails(),
      NotificationType.progress => _progressNotificationDetails(progress),
      NotificationType.complete => _completeNotificationDetails(),
    };
  }

  static NotificationDetails _basicNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _basicChannelId,
        _basicChannelName,
        channelDescription: _basicChannelDesc,
        importance: Importance.high,
        priority: Priority.defaultPriority,
        playSound: true,
        autoCancel: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
      ),
    );
  }

  static NotificationDetails _progressNotificationDetails(int progress) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _downloadChannelId,
        _downloadChannelName,
        channelDescription: _downloadChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        showProgress: true,
        maxProgress: 100,
        progress: progress,
        onlyAlertOnce: true,
        ongoing: false,
        playSound: false,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: false,
        presentBadge: true,
      ),
    );
  }

  static NotificationDetails _completeNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _completeChannelId,
        _completeChannelName,
        channelDescription: _completeChannelDesc,
        importance: Importance.max,
        priority: Priority.high,
        showProgress: false,
        ongoing: false,
        autoCancel: true,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
      ),
    );
  }
}
