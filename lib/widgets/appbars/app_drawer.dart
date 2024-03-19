import 'package:arcjoga_frontend/style.dart';
import 'package:flutter/material.dart';
import 'package:arcjoga_frontend/pages/home.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';
// import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // List<FortuneCategory> categories =
    //     Provider.of<CategoryProvider>(context).categories;
    return Drawer(
      backgroundColor: const Color(Style.drawerDark),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 20.0,
            bottom: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          const Text('KEZDŐLAP', style: Style.textWhiteSmall),
                      onTap: () => Navigator.pushNamed(
                        context,
                        HomePage.routeName,
                      ),
                    );
                    // final category = categories[index - 1];
                    // // Adjust index by -1 to account for the initial item(s)
                    // return ListTile(
                    //   title: Text(
                    //     category.title.toUpperCase(),
                    //     style: Style.textWhiteSmall,
                    //   ),
                    //   onTap: () {
                    //     // Handle category item tap
                    //     Navigator.pop(context);
                    //     Navigator.pushNamed(
                    //       context,
                    //       Fortune.routeName,
                    //       arguments: category,
                    //     );
                    //   },
                    // );
                  },
                ),
              ),
              const SizedBox(height: 20),
              AppTextButton(
                backgroundColor: const Color(Style.primaryDark),
                width: 260,
                text: 'FIÓK BEÁLLÍTÁSOK',
                textStyle: Style.textWhite,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
