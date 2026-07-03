import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
  });

  final String title;

  final List<Widget>? actions;

  final bool centerTitle;

  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {

    return AppBar(

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),

      centerTitle: centerTitle,

      automaticallyImplyLeading:
      automaticallyImplyLeading,

      elevation: 0,

      actions: actions,

    );

  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);

}