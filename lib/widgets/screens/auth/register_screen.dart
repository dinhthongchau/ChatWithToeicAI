import 'package:ct312hm01_temp/common/enum/load_status.dart';
import 'package:ct312hm01_temp/widgets/common_widgets/custom_appbar_auth.dart';
import 'package:ct312hm01_temp/widgets/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/custom_notice_snackbar.dart';
import 'app_auth_provider.dart';

class RegisterScreen extends StatelessWidget {
  static const String route = "/register";
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Page();
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarAuth("Register Page"),
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
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();


  }
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AppAuthProvider>();
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: "Enter Your Email"),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: "Enter your Password"),
          obscureText: true ,
        ),
        TextField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(labelText: "Confirm your Password"),
          obscureText: true ,
        ),
        ElevatedButton(onPressed: (){

            if( authProvider.loadStatus != LoadStatus.Error){
              authProvider.signUpWithEmail(context,_emailController.text, _passwordController.text, _confirmPasswordController.text);
              ScaffoldMessenger.of(context).showSnackBar(
                  customNoticeSnackbar(context,"Sign up ok",false)
              );

            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(
                  customNoticeSnackbar(context,"Please confirm right",true)
              );
            }


        }, child: Text("Sign up"))
      ],
    );
  }
}
