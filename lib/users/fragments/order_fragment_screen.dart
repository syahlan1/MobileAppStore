import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderFragmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff273c75),
      body: Center(
        child: Text(
          "Order Fragment Screen",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
