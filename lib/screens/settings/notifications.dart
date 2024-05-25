import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Update Available',
      'body': 'A new version of our app is now available for download.',
      'time': '3 hours ago',
    },
    {
      'title': 'New Article Published',
      'body':
          'Check out our latest article on the benefits of learning a new language.',
      'time': 'Yesterday',
    },
    {
      'title': 'Upcoming Event',
      'body': 'Don\'t forget to join our webinar on May 30th at 3 PM.',
      'time': '2 days ago',
    },
    {
      'title': 'New Feature Added',
      'body': 'We have added a new feature to help you track your progress.',
      'time': '1 week ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the settings page
            Get.toNamed('/settings');
          },
        ),
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notification['title']!,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification['body']!),
                Text(
                  notification['time']!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
