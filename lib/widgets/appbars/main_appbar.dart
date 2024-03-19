import 'package:arcjoga_frontend/models/user.dart';
import 'package:arcjoga_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:arcjoga_frontend/pages/auth/login.dart';
import 'package:arcjoga_frontend/pages/settings/profile.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool onAuthPage;
  final bool onHomePage;
  final bool showBackBtn;

  const MainAppBar({
    super.key,
    this.onAuthPage = false,
    this.onHomePage = false,
    this.showBackBtn = true,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(
      context,
      listen: false,
    );

    Future<bool> isLoggedIn = authService.isLoggedIn();
    Future<User?> userFuture = isLoggedIn.then((isLoggedIn) {
      if (isLoggedIn) {
        return authService.getUser();
      }
      return null;
    });

    return AppBar(
      backgroundColor: const Color(Style.primaryDark),
      foregroundColor: const Color(Style.white),
      leading: FutureBuilder<User?>(
        future: userFuture,
        builder: (context, snapshot) => _buildLeadingWidget(context, snapshot),
      ),
      title: onAuthPage
          ? null
          : Center(
              child: SvgPicture.asset(
                'assets/images/mystic_text_logo.svg',
                // width: 100,
                height: 36,
              ),
            ),
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
      BuildContext context, AsyncSnapshot<User?> snapshot) {
    if (snapshot.connectionState == ConnectionState.done &&
        snapshot.hasData &&
        (!showBackBtn || onHomePage)) {
      final user = snapshot.data;

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
            backgroundImage: user!.avatarUrl != null
                ? NetworkImage(
                    user.avatarUrl!,
                  )
                : const AssetImage('assets/icons/profile_icon.png')
                    as ImageProvider,
          ),
        ),
      );
    } else if ((!onAuthPage && !(snapshot.hasData) && !showBackBtn) ||
        onHomePage) {
      return IconButton(
        icon: Image.asset(
          'assets/icons/profile_icon.png',
          height: 28,
        ),
        onPressed: () => Navigator.pushNamed(
          context,
          snapshot.hasData ? Profile.routeName : Login.routeName,
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
