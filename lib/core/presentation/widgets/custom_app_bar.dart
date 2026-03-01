import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';

class AppToolBar extends StatefulWidget implements PreferredSizeWidget {
  const AppToolBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.backgroundColor,
  });

  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;

  @override
  State<AppToolBar> createState() => _AppToolBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppToolBarState extends State<AppToolBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
        width: double.infinity,
        height: kToolbarHeight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (widget.showBackButton)
                IconButton(
                  onPressed: () => context.go(AppRouter.productPath),
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                )
              else
                SizedBox(),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextTheme.of(context).titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
