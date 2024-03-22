import 'package:arcjoga_frontend/models/user.dart';
import 'package:arcjoga_frontend/providers/user_provider.dart';
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
    var userProvider = Provider.of<UserProvider>(context);

    Future<bool> isLoggedIn = userProvider.isUserLoggedIn();
    Future<User?> userFuture = isLoggedIn.then((isLoggedIn) {
      if (isLoggedIn) {
        return userProvider.fetchUser();
      }
      return null;
    });

    return AppBar(
      backgroundColor: const Color(Style.primaryDark),
      foregroundColor: const Color(Style.primaryLight),
      centerTitle: true,
      leading: FutureBuilder<User?>(
        future: userFuture,
        builder: (context, snapshot) => _buildLeadingWidget(context, snapshot),
      ),
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
                : const AssetImage('assets/icons/arc_profile_icon.png')
                    as ImageProvider,
          ),
        ),
      );
    } else if ((!onAuthPage && !(snapshot.hasData) && !showBackBtn) ||
        onHomePage) {
      return IconButton(
        icon: Image.asset(
          'assets/icons/arc_profile_icon.png',
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
