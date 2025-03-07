import 'package:ct312hm01_temp/presentation/screens/auth/app_auth_provider.dart';
import 'package:ct312hm01_temp/presentation/screens/guide/guide_screen.dart';
import 'package:ct312hm01_temp/presentation/screens/setting/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/login_screen.dart';

void showSettingDialog(BuildContext context){
  showDialog(

    context: context,
  builder: (context){
      return AlertDialog(
        title: const Text("Settings"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ThemeModeChange(),
            NavigateToGuideScreen(),
          ],
        ),
        actions: [
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                SignOutButton(),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close")),
              ],
            ),
        ],
      );
  }


  );
}


class NavigateToGuideScreen extends StatelessWidget {
  const NavigateToGuideScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.question_mark),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(GuideScreen.route);
            },
            child: Text("How to use this app ? ")),
      ],
    );
  }
}

class ThemeModeChange extends StatelessWidget {
  const ThemeModeChange({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.light_mode),
        Text("   Open Light Mode"),
        Switch(
            value: context.read<ThemeProvider>().isLightTheme,
            onChanged: (bool value) {
              context.read<ThemeProvider>().setTheme(value);
            }),
      ],
    );
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: (){
      context.read<AppAuthProvider>().signOut();
      Navigator.of(context).pushNamed(LoginScreen.route);
    }, child: Row(
      children: [
        Icon(Icons.exit_to_app),
        Text("Sign out"),
      ],
    ));
  }
}
