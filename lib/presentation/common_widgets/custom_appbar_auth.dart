import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/setting/theme_provider.dart';

class CustomAppBarAuth extends StatelessWidget implements PreferredSizeWidget {
  final String textAppbar ;

  const CustomAppBarAuth(this.textAppbar, {super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: context.read<ThemeProvider>().backgroundColor,title: Text(textAppbar,style: TextStyle(color: context.read<ThemeProvider>().textColor,fontSize: 15),));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}