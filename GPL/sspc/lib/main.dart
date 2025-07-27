import 'package:flutter/material.dart';
import 'package:sspc/AdminDashboard.dart';
import 'package:sspc/Adminpanel.dart';
import 'package:sspc/Userprofile.dart';
import 'package:sspc/dashboard.dart';
import 'package:sspc/index.dart';
import 'package:sspc/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sspc/payment_gateway.dart';

//Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// print("Background Message: ${message.messageId}");
//}

//void main() async {
// WidgetsFlutterBinding.ensureInitialized();
//await Firebase.initializeApp();

//FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

// runApp(MyApp());
//}

//class MyApp extends StatefulWidget {
// @override
// _MyAppState createState() => _MyAppState();
//}

//class _MyAppState extends State<MyApp> {
// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

// @override
//void initState() {
//   super.initState();
// _initializeFirebaseMessaging();
// }

// void _initializeFirebaseMessaging() async {
// Request permissions
//NotificationSettings settings = await _firebaseMessaging.requestPermission();
//print("Notification permission: ${settings.authorizationStatus}");

// Get the FCM token
//String? token = await _firebaseMessaging.getToken();
// print("FCM Token: $token");

// Send the token to the backend
//if (token != null) {
// _sendTokenToServer(token);
// }

// Handle foreground messages
//FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//  print("Foreground Notification: ${message.notification?.title}");
//});

// Handle notification click (when app is opened by clicking notification)
//  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//  print("Notification Clicked: ${message.notification?.title}");
// });
// }

//void _sendTokenToServer(String token) async {
//  String userId = "USER_ID_HERE"; // Replace with actual logged-in user ID

// var response = await http.post(
//  Uri.parse("http://yourserver.com/api/update-token"),
// headers: {"Content-Type": "application/json"},
//  body: jsonEncode({"userId": userId, "fcmToken": token}),
// );

// if (response.statusCode == 200) {
//   print("Token updated on server successfully!");
// } else {
//   print("Failed to update token on server.");
// }
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Programming League',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: const Color(0xFF1A237E), // Dark navy blue
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}
