

import 'package:ct312hm01_temp/widgets/common_widgets/custom_appbar_auth.dart';
import 'package:ct312hm01_temp/widgets/screens/auth/app_auth_provider.dart';
import 'package:ct312hm01_temp/widgets/screens/auth/register_screen.dart';
import 'package:ct312hm01_temp/widgets/screens/chat/chat_screen.dart';
import 'package:ct312hm01_temp/widgets/screens/setting/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/enum/load_status.dart';

class LoginScreen extends StatelessWidget {
  static const String route = "/login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarAuth("Login Page"),
      body: Body(),
    );
  }
}


class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();


  }
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AppAuthProvider>();
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: "Email"),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: "Password"),
          obscureText: true ,
        ),
        ElevatedButton(onPressed: (){
          authProvider.loginWithEmail(context, _emailController.text, _passwordController.text);
          if ( authProvider.loadStatus == LoadStatus.Done) {
            Navigator.of(context).pushNamed(ChatScreen.route);
          };
        }, child: Text("Login")),
        TextButton(onPressed: (){
          Navigator.of(context).pushNamed(RegisterScreen.route);
        }, child: Text("Register")),
      ],
    );
  }
}
