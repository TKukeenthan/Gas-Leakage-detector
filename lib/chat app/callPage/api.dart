import 'dart:convert';
import 'package:gldapplication/chatUser.dart';
import 'package:http/http.dart' as http;

class Api {
  static const String apiUrl = "API_URL/LOCALHOST";

  static sendNotificationRequestToFriendToAcceptCall(
      String roomId, ChatUser user) async {
    var data = jsonEncode({
      "uuid": user.id,
      "caller_id": user.mobile_number,
      "caller_name": user.name,
      "caller_id_type": "number",
      "has_video": "false",
      "room_id": roomId,
      "fcm_token": user.pushToken
    });
    var r = await http.post(Uri.parse("$apiUrl/send-notification"),
        body: data, headers: {"Content-Type": "application/json"});
    print(r.body);
  }
}
