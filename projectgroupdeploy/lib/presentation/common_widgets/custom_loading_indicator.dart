import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final Color color;
  final double size;

  const CustomLoadingIndicator({super.key, 
    this.color = Colors.blue,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}