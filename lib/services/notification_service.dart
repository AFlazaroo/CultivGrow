import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/tarea_programada.dart';
import '../models/tipo_tarea.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Manejar cuando se toca una notificación
    // Puedes navegar a la pantalla correspondiente aquí
  }

  Future<void> scheduleTaskNotification(TareaProgramada tarea, String cultivoNombre) async {
    if (!tarea.activa || tarea.proximaEjecucion == null) return;

    await initialize();

    final androidDetails = AndroidNotificationDetails(
      'tareas_cultivos',
      'Tareas de Cultivos',
      channelDescription: 'Notificaciones para tareas programadas de cultivos',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final scheduledDate = tz.TZDateTime.from(
      tarea.proximaEjecucion!,
      tz.local,
    );

    final nombreTarea = tarea.tipoTarea.nombre;
    await _notifications.zonedSchedule(
      tarea.id ?? 0,
      'Tarea: $nombreTarea',
      '${tarea.descripcion} - $cultivoNombre',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelTaskNotification(int taskId) async {
    await _notifications.cancel(taskId);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> updateTaskNotification(TareaProgramada tarea, String cultivoNombre) async {
    await cancelTaskNotification(tarea.id ?? 0);
    if (tarea.activa) {
      await scheduleTaskNotification(tarea, cultivoNombre);
    }
  }
}

