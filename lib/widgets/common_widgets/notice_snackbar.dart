import 'package:flutter/material.dart';

SnackBar noticeSnackbar(BuildContext context, String message, bool isError) {
  return SnackBar(
    content: Text(message,style: TextStyle(color: Colors.white),),
    backgroundColor: isError ? Colors.red : Colors.black12,
    duration: Duration(seconds: 2),
    action: SnackBarAction(label: 'Close', onPressed: (){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }),
  );
}
