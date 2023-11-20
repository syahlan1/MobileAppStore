import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:store_app/users/fragments/favorites_fragment_screen.dart';
import 'package:store_app/users/fragments/home_fragment_screen.dart';
import 'package:store_app/users/fragments/order_fragment_screen.dart';
import 'package:store_app/users/fragments/profile_fragment_screen.dart';
import 'package:store_app/users/userPreferences/current_user.dart';

class DashboardOfFragments extends StatelessWidget {
  CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  final List<Widget> _fragmentScreens = [
    HomeFragmentScreen(),
    FavoritesFragmentScreen(),
    OrderFragmentScreen(),
    ProfileFragmentScreen(),
  ];

  final List _navigationButtonsProperties = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home",
    },
    {
      "active_icon": Icons.favorite,
      "non_active_icon": Icons.favorite_border,
      "label": "Favorite",
    },
    {
      "active_icon": Icons.receipt,
      "non_active_icon": Icons.receipt_outlined,
      "label": "Transaksi",
    },
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person,
      "label": "Profile",
    },
  ];

  RxInt _indexNumber = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: ((controller) {
        return Scaffold(
          backgroundColor: Color(0xfff1f2f6),
          body: SafeArea(
            child: Obx(() => _fragmentScreens[_indexNumber.value]),
          ),
          bottomNavigationBar: Obx(
            () => ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomNavigationBar(
                currentIndex: _indexNumber.value,
                onTap: (value) {
                  _indexNumber.value = value;
                },
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: Color(0xfff6b93b),
                unselectedItemColor: Colors.white,
                items: List.generate(4, (index) {
                  var navBtnProperty = _navigationButtonsProperties[index];
                  return BottomNavigationBarItem(
                    backgroundColor: Color(0xff575fcf),
                    icon: Icon(navBtnProperty["non_active_icon"]),
                    activeIcon: Icon(navBtnProperty["active_icon"]),
                    label: navBtnProperty["label"],
                  );
                }),
              ),
            ),
          ),
        );
      }),
    );
  }
}
