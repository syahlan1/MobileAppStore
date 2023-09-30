import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoritesFragmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff273c75),
      body: Center(
        child: Text(
          "Favorite Fragment Screen",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
