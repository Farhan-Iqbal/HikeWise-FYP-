import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _weatherAlerts = true;
  bool _hikeReminders = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Weather Alerts"),
            subtitle: const Text("Get notified if trail conditions change"),
            value: _weatherAlerts,
            onChanged: (val) => setState(() => _weatherAlerts = val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Hike Reminders"),
            subtitle: const Text("Reminders for your scheduled hikes"),
            value: _hikeReminders,
            onChanged: (val) => setState(() => _hikeReminders = val),
          ),
        ],
      ),
    );
  }
}