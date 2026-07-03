import 'package:flutter/material.dart';

import '../app_card.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;

  final String title;

  final String subtitle;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {

    return AppCard(

      onTap: onTap,

      child: ListTile(

        leading: CircleAvatar(
          child: Icon(icon),
        ),

        title: Text(title),

        subtitle: Text(subtitle),

        trailing: const Icon(
          Icons.chevron_right,
        ),

      ),

    );

  }

}