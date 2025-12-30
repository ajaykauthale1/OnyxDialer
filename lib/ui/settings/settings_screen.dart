import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _openSystemSetting(String action) async {
    final intent = AndroidIntent(
      action: action,
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.wifi_calling_3),
            title: const Text('Wi-Fi Calling'),
            onTap: () => _openSystemSetting('android.settings.WIFI_CALLING_SETTINGS'),
          ),
          ListTile(
            leading: const Icon(Icons.sim_card),
            title: const Text('SIM & Network'),
            onTap: () => _openSystemSetting('android.settings.WIRELESS_SETTINGS'),
          ),
          ListTile(
            leading: const Icon(Icons.data_usage),
            title: const Text('Data Usage'),
            onTap: () => _openSystemSetting('android.settings.DATA_ROAMING_SETTINGS'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Blocked Numbers'),
            subtitle: const Text('Manage local block list'),
            onTap: () {
              // TODO: Navigate to internal Block List screen
            },
          ),
        ],
      ),
    );
  }
}
