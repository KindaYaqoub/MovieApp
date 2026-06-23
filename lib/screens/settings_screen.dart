import 'package:flutter/material.dart';

import '../main.dart';
import 'about_screen.dart';
import 'team_members_screen.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';



class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        MyApp.themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDark,
            activeColor: const Color(0xFF00CCFF),
            onChanged: (value) {
              MyApp.themeNotifier.value =
                  value ? ThemeMode.dark : ThemeMode.light;
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.info,
              color: Color(0xFF00CCFF),
            ),
            title: const Text('About App'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),

          ListTile(
  leading: const Icon(
    Icons.group,
    color: Color(0xFFFF3300),
  ),
  title: const Text('Team Members'),
  trailing: const Icon(
    Icons.arrow_forward_ios,
    size: 16,
  ),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TeamMembersScreen(),
      ),
    );
  },
),

const Divider(),

ListTile(
  leading: const Icon(
    Icons.logout,
    color: Colors.redAccent,
  ),
  title: const Text('Logout'),
  onTap: () async {
    await AuthService().signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  },
),


        ],
      ),
    );
  }
}