// ignore_for_file: file_names

import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final dynamic notification;
  final VoidCallback onTap;

  const NotificationItem(
      {super.key, required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final icon = notification['type'] == 'chat'
        ? const Icon(Icons.chat)
        : const Icon(Icons.warning);

    return ListTile(
      leading: icon,
      title: Text(notification['title']),
      subtitle: Text(notification['body']),
      onTap: onTap,
    );
  }
}
