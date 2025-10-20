import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class CreateNotificationModel {
  String title;
  String body;
  String type;
  DateTime? scheduledAt;
  String? reference;
  String? uid;


  CreateNotificationModel({
    required this.title,
    required this.body,
    required this.type,
    this.scheduledAt,
    this.reference,
    this.uid
  });

  Map<String,dynamic> get toMap {
    return {
      "type":type,
      "title":title,
      "body":body,
      if(scheduledAt != null)
        "scheduledAt":scheduledAt,
      if(reference != null)
        "reference":reference,
      if(uid != null)
        "uid":uid,
      "sent":false
    };
  }
}

class NotificationsService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  scheduleNotification(CreateNotificationModel notification) async {
    await _firestore.collection("notificationQueue").add(notification.toMap);
  }

  Future<AccessCredentials> _getAccessToken() async {
    final serviceAccountPath = dotenv.env['PATH_TO_SECRET'];
    log(serviceAccountPath??"");

    String serviceAccountJson = await rootBundle.loadString(
      serviceAccountPath!,
    );

    // log("json: $serviceAccountJson");
    final serviceAccount = ServiceAccountCredentials.fromJson(
      serviceAccountJson,
    );

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final client = await clientViaServiceAccount(serviceAccount, scopes);
    return client.credentials;
  }

  Future<bool> sendPushNotification({
    required String topic,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    if (topic.isEmpty) return false;

    final credentials = await _getAccessToken();
    final accessToken = credentials.accessToken.data;
    final projectId = dotenv.env['PROJECT_ID'];

    log("accessToken: ${dotenv.env['PROJECT_ID']}");

    final url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
    );

    log(url.toString());
    print(topic);

    final message = {
      'message': {
        'topic': topic,
        'notification': {'title': title, 'body': body},
        'data': data ?? {},
      },
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully.');
      return true;
    } else {
      print('Failed to send notification: ${response.body}');
      return false;
    }
  }

}