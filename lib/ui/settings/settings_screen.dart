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
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Connectivity'),
          _buildSettingItem(
            icon: Icons.wifi_calling_3,
            title: 'Wi-Fi Calling',
            onTap: () => _openSystemSetting('android.settings.WIFI_CALLING_SETTINGS'),
          ),
          _buildSettingItem(
            icon: Icons.sim_card,
            title: 'SIM & Network',
            onTap: () => _openSystemSetting('android.settings.WIRELESS_SETTINGS'),
          ),
          _buildSettingItem(
            icon: Icons.data_usage,
            title: 'Data Usage',
            onTap: () => _openSystemSetting('android.settings.DATA_ROAMING_SETTINGS'),
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Call Settings'),
          _buildSettingItem(
            icon: Icons.block,
            title: 'Blocked Numbers',
            subtitle: 'Manage local block list',
            onTap: () {
              // TODO: Navigate to internal Block List screen
            },
          ),
          _buildSettingItem(
            icon: Icons.voicemail,
            title: 'Voicemail',
            onTap: () => _openSystemSetting('android.telephony.action.CONFIGURE_VOICEMAIL'),
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader('About'),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: 'v6.0 (Ghost Protocol)',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.green, // Neon Green accent
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
