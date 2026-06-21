import 'package:flutter/material.dart';

class TeamMembersScreen extends StatelessWidget {
  const TeamMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final members = [
      'Mayar Albesher',
      'Ansam Hamayel',
      'Leen Naser',
      'Yousra Issa',
      'Kinda Yaqoup',
    ];

    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Team Members'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: members.length,
        itemBuilder: (context, index) {
          return Card(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: const Icon(
                Icons.person,
                color: Color(0xFF00CCFF),
              ),
              title: Text(
                members[index],
                style: TextStyle(
                  color: textColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}