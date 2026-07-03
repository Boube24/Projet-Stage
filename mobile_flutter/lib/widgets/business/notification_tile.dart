import 'package:flutter/material.dart';

import '../../core/utils/date_formatter.dart';
import '../../models/notification_model.dart';
import '../app_card.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  final NotificationModel notification;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {

    return AppCard(

      onTap: onTap,

      child: Row(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          CircleAvatar(

            backgroundColor:
            notification.isRead
                ? Colors.grey.shade300
                : Colors.blue.shade100,

            child: Icon(

              notification.isRead
                  ? Icons.notifications_none
                  : Icons.notifications_active,

              color: notification.isRead
                  ? Colors.grey
                  : Colors.blue,

            ),

          ),

          const SizedBox(width: 16),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  notification.title,

                  style: TextStyle(

                    fontSize: 16,

                    fontWeight:
                    notification.isRead
                        ? FontWeight.w500
                        : FontWeight.bold,

                  ),

                ),

                const SizedBox(height: 6),

                Text(
                  notification.message,
                ),

                const SizedBox(height: 10),

                Text(

                  DateFormatter.formatDateTime(
                    notification.sendAt,
                  ),

                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),

                ),

              ],

            ),

          ),

          if (!notification.isRead)

            Container(

              width: 10,

              height: 10,

              decoration: const BoxDecoration(

                color: Colors.red,

                shape: BoxShape.circle,

              ),

            ),

        ],

      ),

    );

  }

}