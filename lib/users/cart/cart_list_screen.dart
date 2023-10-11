import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app/users/userPreferences/current_user.dart';

class CartListScreen extends StatefulWidget {
  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  final currentOnlineUser = Get.put(CurrentUser());

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
