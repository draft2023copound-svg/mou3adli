import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// 💬 Service de notifications style MESSENGER
/// - Heads-up notification (flottante en haut de l'écran)
/// - Son court "pop" discret
/// - Icône de l'app en grand
/// - Swipe pour ignorer, tap pour ouvrir
/// - Groupement des notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// 🚀 Initialisation
  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('💬 Notification tapped: ${details.payload}');
      },
    );

    _initialized = true;
  }

  /// 💬 Notification style MESSENGER (heads-up)
  Future<void> showMessengerNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    // Android : Style Messenger avec heads-up
    final androidDetails = AndroidNotificationDetails(
      'mou3adli_messenger',
      'Mou3adli Messenger',
      channelDescription: 'Notifications style Messenger',

      // ✅ HEADS-UP : Notification flottante en haut de l'écran
      importance: Importance.max,
      priority: Priority.high,

      // ✅ SON MESSENGER : Court "pop" discret
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      playSound: true,

      // ✅ VIBRATION LÉGÈRE style Messenger
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 100, 50, 100]),

      // ✅ ICÔNE EN GRAND (style Messenger)
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      icon: '@mipmap/ic_launcher',

      // ✅ STYLE MESSENGER : Bulle de conversation
      styleInformation: MessagingStyleInformation(
        Person(name: 'Mou3adli'),
        groupConversation: false,
        messages: [],
      ),

      // ✅ ACTIONS RAPIDES (comme Messenger)
      actions: [
        const AndroidNotificationAction(
          'open',
          'Ouvrir',
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          'dismiss',
          'Ignorer',
          cancelNotification: true,
        ),
      ],

      // ✅ COULEUR DE L'APP
      color: const Color(0xFF1C3F7A),
      colorized: true,

      // ✅ FULL SCREEN INTENT (comme un appel Messenger)
      fullScreenIntent: false,

      // ✅ GROUPEMENT
      groupKey: 'mou3adli_events',
      setAsGroupSummary: false,

      channelShowBadge: true,
      visibility: NotificationVisibility.public,
    );

    // iOS : Style Messenger
    const darwinDetails = DarwinNotificationDetails(
      sound: 'notification_sound.aiff',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive, // ✅ Priorité haute
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// ⏰ Programmer une notification style Messenger
  Future<void> scheduleMessengerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    final androidDetails = AndroidNotificationDetails(
      'mou3adli_scheduled',
      'Rappels Mou3adli',
      channelDescription: 'Rappels pour événements scolaires',

      // ✅ HEADS-UP
      importance: Importance.max,
      priority: Priority.high,

      // ✅ SON MESSENGER
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      playSound: true,

      // ✅ VIBRATION LÉGÈRE
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 100, 50, 100]),

      // ✅ ICÔNE
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      icon: '@mipmap/ic_launcher',

      // ✅ STYLE MESSENGER
      styleInformation: MessagingStyleInformation(
        Person(name: 'Mou3adli'),
        groupConversation: false,
        messages: [],
      ),

      // ✅ ACTIONS
      actions: [
        const AndroidNotificationAction('open', 'Ouvrir', showsUserInterface: true),
        const AndroidNotificationAction('dismiss', 'Ignorer', cancelNotification: true),
      ],

      color: const Color(0xFF1C3F7A),
      colorized: true,
      channelShowBadge: true,
      visibility: NotificationVisibility.public,
    );

    const darwinDetails = DarwinNotificationDetails(
      sound: 'notification_sound.aiff',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// 📅 Programmer les 4 rappels style Messenger
  Future<void> scheduleEventReminders({
    required String eventId,
    required String eventTitle,
    required DateTime eventDate,
  }) async {
    final baseId = eventId.hashCode.abs();

    // 1 semaine avant
    final weekBefore = eventDate.subtract(const Duration(days: 7));
    if (weekBefore.isAfter(DateTime.now())) {
      await scheduleMessengerNotification(
        id: baseId + 1,
        title: '📅 $eventTitle',
        body: 'Dans 1 semaine — Prépare-toi bien !',
        scheduledDate: weekBefore,
        payload: eventId,
      );
    }

    // 3 jours avant
    final threeDaysBefore = eventDate.subtract(const Duration(days: 3));
    if (threeDaysBefore.isAfter(DateTime.now())) {
      await scheduleMessengerNotification(
        id: baseId + 2,
        title: '⏰ $eventTitle',
        body: 'Dans 3 jours !',
        scheduledDate: threeDaysBefore,
        payload: eventId,
      );
    }

    // 1 jour avant
    final oneDayBefore = eventDate.subtract(const Duration(days: 1));
    if (oneDayBefore.isAfter(DateTime.now())) {
      await scheduleMessengerNotification(
        id: baseId + 3,
        title: '🔔 $eventTitle',
        body: 'C\'est demain ! Bonne chance 🍀',
        scheduledDate: oneDayBefore,
        payload: eventId,
      );
    }

    // Jour J à 8h
    final dayOf = DateTime(eventDate.year, eventDate.month, eventDate.day, 8, 0);
    if (dayOf.isAfter(DateTime.now())) {
      await scheduleMessengerNotification(
        id: baseId + 4,
        title: '🎉 $eventTitle',
        body: 'C\'est aujourd\'hui !',
        scheduledDate: dayOf,
        payload: eventId,
      );
    }
  }

  /// 🗑️ Annuler
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}