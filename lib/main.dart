import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ticket_wise/homepage_transition/homepage.dart';
import 'package:ticket_wise/screens/main_screen.dart';
import 'package:ticket_wise/services/app_provider.dart';
import 'package:ticket_wise/widgets/constants.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupFirebaseMessaging();
  runApp(const MyApp());
}

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for iOS
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  await messaging
      .subscribeToTopic('events')
      .then((_) {})
      .catchError((error) {});

  // Get the device token
  String? token = await messaging.getToken();
  print('token: $token');

  // Initialize local notifications and create notification channel
  await initializeLocalNotifications();

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Set up foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received a message: ${message.notification?.title}');
    showNotification(message);
  });
}

// Initialize local notifications and create a channel
Future<void> initializeLocalNotifications() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // ID
    'High Importance Notifications', // Name
    description:
        'This channel is used for important notifications.', // Description
    importance: Importance.high,
  );

  // Initialize the plugin
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create the notification channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.notification?.title}');
  showNotification(message);
}

// Show a local notification
void showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'high_importance_channel', // Channel ID (matches the one created)
    'High Importance Notifications', // Channel name
    channelDescription: 'This channel is used for important notifications.',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformDetails,
    payload: message.data.toString(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData) {
              return const Mainscreen();
            } else {
              return const HomePage();
            }
          },
        ),
        builder: EasyLoading.init(),
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: PrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
      ),
    );
  }
}
