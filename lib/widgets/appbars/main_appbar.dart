import 'package:arcjoga_frontend/models/user.dart';
import 'package:arcjoga_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:arcjoga_frontend/pages/auth/login.dart';
import 'package:arcjoga_frontend/pages/settings/profile.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool onAuthPage;
  final bool onHomePage;
  final bool showBackBtn;
  final String? title;

  const MainAppBar({
    super.key,
    this.onAuthPage = false,
    this.onHomePage = false,
    this.showBackBtn = true,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final isLoggedIn = userProvider.isLoggedIn;

    return AppBar(
      backgroundColor: const Color(Style.primaryDark),
      foregroundColor: const Color(Style.primaryLight),
      centerTitle: true,
      leading: _buildLeadingWidget(context, user, isLoggedIn),
      title: onAuthPage ? null : Text(title ?? ''),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.menu,
            size: 32,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ],
    );
  }

  Widget _buildLeadingWidget(
    BuildContext context,
    User? user,
    bool isLoggedIn,
  ) {
    if (user != null && (!showBackBtn || onHomePage) && isLoggedIn) {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(context, Profile.routeName),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
            left: 15,
            right: 0,
          ),
          child: CircleAvatar(
            radius: 18,
            backgroundImage: user.avatarUrl != null
                ? NetworkImage(
                    user.avatarUrl!,
                  )
                : const AssetImage('assets/icons/arc_profile_icon.png')
                    as ImageProvider,
          ),
        ),
      );
    } else if ((!onAuthPage && user == null && !showBackBtn) || onHomePage) {
      return IconButton(
        icon: Image.asset(
          'assets/icons/arc_profile_icon.png',
          height: 28,
        ),
        onPressed: () => Navigator.pushNamed(
          context,
          Login.routeName,
        ),
      );
    } else if (showBackBtn) {
      return IconButton(
        icon: const Icon(Icons.chevron_left, size: 32),
        onPressed: () => Navigator.of(context).pop(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
