import 'package:ct312hm01_temp/widgets/screens/chat/chat_screen.dart';
import 'package:ct312hm01_temp/widgets/screens/guide/guide_screen.dart';
import 'package:ct312hm01_temp/widgets/screens/setting/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  static const String route = "/setting";

  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      bottomNavigationBar:
          IconButton(onPressed: () {

            Navigator.of(context).pushNamed(ChatScreen.route);
          }, icon: Icon(Icons.home_outlined)),
      body: Column(

        children: [
          ThemeModeChange(),
          NavigateToGuideScreen()
        ],
      ),
    );
  }
}

class NavigateToGuideScreen extends StatelessWidget {
  const NavigateToGuideScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: ()
      {
        Navigator.of(context).pushNamed(GuideScreen.route);
      }
    , child: Text("How to use this app ? "));
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
        Text("Open Light Mode"),
        Switch(value: context.read<ThemeProvider>().isLightTheme, onChanged: (bool value){
          context.read<ThemeProvider>().setTheme(value);
        }),

      ],
    );
  }
}
