import 'package:ct312hm01_temp/widgets/screens/chat/chat_screen.dart';
import 'package:ct312hm01_temp/widgets/screens/guide/guide_screen.dart';
import 'package:flutter/material.dart';

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
          Text("Setting Screen"),
          Text("Setting Screen"),
          TextButton(onPressed: ()
            {
              Navigator.of(context).pushNamed(GuideScreen.route);
            }
          , child: Text("How to use this app ? "))
        ],
      ),
    );
  }
}
