import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:store_app/seller/home_seller.dart';
import 'package:store_app/users/authentication/login_screen.dart';
import 'package:store_app/users/userPreferences/current_user.dart';
import 'package:store_app/users/userPreferences/user_preferences.dart';

class ProfileFragmentScreen extends StatelessWidget {
  final CurrentUser _currentUser = Get.put(CurrentUser());

  signOutUser() async {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Logout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: const Text(
          "Apa kamu yakin?\nYakin ingin logout dari akun ini?",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          Material(
            color: Color(0xff6b83bc),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                child: Text(
                  "No",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                Get.back(result: "loggedOut");
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ],
      ),
    );

    if (resultResponse == "loggedOut") {
      //delete-remove the user data from phone local storage
      RememberUserPrefs.removeUserInfo().then((value) {
        Get.off(LoginScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 220,
              color: Color(0xff6b83bc),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "images/man.png",
                      width: 90,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _currentUser.user.user_name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _currentUser.user.user_email,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            ListTile(
              leading: Icon(Icons.storefront),
              title: Text("Toko Saya"),
              onTap: () {
                Get.to(HomeSeller());
              },
              trailing: Icon(Icons.chevron_right_rounded),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text("Bahasa"),
              onTap: () {},
              trailing: Icon(Icons.chevron_right_rounded),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.redAccent,
              ),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.redAccent),
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: Colors.redAccent,
              ),
              onTap: () {
                signOutUser();
              },
            ),
          ],
        ),
      ),
    );
  }
}
