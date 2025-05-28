import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.backgroundColor,
    this.centerTitle = true,
  }) : super(key: key);

  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      title: Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      backgroundColor: backgroundColor ?? Colors.white,
      centerTitle: centerTitle,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      actions: actions,
      iconTheme: const IconThemeData(color: Colors.black87),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: const Color(0xFFE0E0E0).withOpacity(0.3),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
