import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:store_app/users/fragments/dashboard_of_fragments.dart';
import 'package:store_app/users/userPreferences/current_user.dart';

class HomeSeller extends StatefulWidget {
  const HomeSeller({super.key});

  @override
  State<HomeSeller> createState() => _HomeSellerState();
}

class _HomeSellerState extends State<HomeSeller> {
  final CurrentUser _currentUser = Get.put(CurrentUser());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(DashboardOfFragments());
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          'Toko Saya',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff6b83bc),
        elevation: 0.0,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    color: Color(0xff6b83bc),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(180),
                      bottomLeft: Radius.circular(180),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(top: 65, left: 35, right: 35),
                        height: 185,
                        // ignore: sort_child_properties_last
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                top: 80,
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Pesanan Baru",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff7f8c8d),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 22,
                                  ),
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff34495e),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height:
                                  80, // Sesuaikan dengan tinggi yang diinginkan
                              width: 1, // Lebar pemisah
                              color: Color(0xff95a5a6),
                              margin: EdgeInsets.only(
                                top: 85,
                                left: 35,
                                right: 35,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 80),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Total Produk",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff7f8c8d),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 22,
                                  ),
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff34495e),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(
                                  1, 10), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        margin: const EdgeInsets.only(top: 35),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        _currentUser.user.user_name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff34495e),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: Image.asset(
                      "images/man.png",
                      width: 50,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                left: 35,
                top: 40,
                bottom: 5,
              ),
              child: Row(
                children: [
                  Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2c3e50),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 30,
                right: 30,
              ),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(15),
                      child: ListTile(
                        leading: Icon(
                          Icons.fact_check,
                          color: Color(0xff6b83bc),
                        ),
                        title: Text('Pemesanan'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(15),
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.boxesPacking,
                          color: Color(0xff6b83bc),
                        ),
                        title: Text('Tambah Dagangan'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(15),
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.boxesStacked,
                          color: Color(0xff6b83bc),
                        ),
                        title: Text('Daganganku'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 35,
                top: 40,
                bottom: 5,
              ),
              child: Row(
                children: [
                  Text(
                    "Baru Kamu Tambah",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2c3e50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      HomeSeller();
    });
  }
}
