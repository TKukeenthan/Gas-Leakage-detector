import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gldapplication/chatUser.dart';

class NotificationScreen extends StatefulWidget {
  final ChatUser user;

  const NotificationScreen({super.key, required this.user});
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List notifications = [];

  @override
  void initState() {
    super.initState();
    _getNotifications();
  }

  Future<void> _getNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await firestore
        .collection('notifications')
        .where('receiver', isEqualTo: user?.email)
        .orderBy('createdAt', descending: true)
        .get();
    setState(() {
      notifications = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            child: InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(Icons.notifications),
                title: Text(notification['sender']),
                subtitle: Text(notification['message']),
                trailing: Text(notification['createdAt']),
              ),
            ),
          );
        },
      ),
    );
  }
}
