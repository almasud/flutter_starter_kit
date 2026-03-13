import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';

class AppToolBar extends StatelessWidget implements PreferredSizeWidget {
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
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: backgroundColor ?? Theme.of(context).colorScheme.primary,
        width: double.infinity,
        height: kToolbarHeight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRouter.loginPath);
                    }
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                )
              else
                const SizedBox(),
              Expanded(
                child: Text(
                  title,
                  style: TextTheme.of(context).titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}
