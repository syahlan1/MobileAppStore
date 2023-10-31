import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:store_app/admin/admin_upload_items.dart';
import 'package:store_app/api_connection/api_connection.dart';
import 'package:store_app/users/authentication/login_screen.dart';
import 'package:store_app/users/model/order.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/users/order/order_details.dart';
import 'package:store_app/users/userPreferences/current_user.dart';
import 'package:intl/intl.dart';

class AdminGetAllOrdersScreen extends StatelessWidget {
  final currentOnlineUser = Get.put(CurrentUser());

  signOutAdmin() async {
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
      Get.off(LoginScreen());
    }
  }

  Future<List<Order>> getAllOrdersList() async {
    List<Order> ordersList = [];

    try {
      var res = await http.post(Uri.parse(API.adminGetAllOrders), body: {});

      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserOrdersList = jsonDecode(res.body);

        if (responseBodyOfCurrentUserOrdersList['success'] == true) {
          (responseBodyOfCurrentUserOrdersList['allOrdersData'] as List)
              .forEach((eachOrderData) {
            ordersList.add(Order.fromJson(eachOrderData));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
    }

    return ordersList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: Color(0xff6b83bc),
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  onTap: () {
                    Get.to(AdminUploadItemsScreen());
                  },
                  borderRadius: BorderRadius.circular(5),
                  child: Padding(
                    padding: EdgeInsets.all(7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        Text(
                          "Produk Baru",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: TextButton(
                  onPressed: () {
                    signOutAdmin();
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xff6b83bc),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //displayin the user orderList
          Expanded(
            child: displayOrdersList(context),
          ),
        ],
      ),
    );
  }

  displayOrdersList(context) {
    NumberFormat formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
    );
    return FutureBuilder(
      future: getAllOrdersList(),
      builder: (context, AsyncSnapshot<List<Order>> dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  "Connection Waiting...",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        if (dataSnapshot.data == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  "No Order found yet",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        if (dataSnapshot.data!.isNotEmpty) {
          List<Order> orderList = dataSnapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) {
              return Divider(
                height: 1,
                thickness: 1,
              );
            },
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              Order eachOrderData = orderList[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.fromLTRB(
                  index == 0 ? 16 : 8,
                  10,
                  index == dataSnapshot.data!.length - 1 ? 16 : 8,
                  10,
                ),
                color: Colors.white,
                elevation: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Get.to(OrderDetailsScreen(clickedOrderInfo: eachOrderData));
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order ID # " +
                                    eachOrderData.order_id.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Material(
                                color: Color(0xffFFCDD2),
                                borderRadius: BorderRadius.circular(5),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "Baru",
                                    style: TextStyle(
                                        color: Color(0xffd63031),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              //date
                              //time
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat("dd MMMM, yyyy")
                                        .format(eachOrderData.dateTime!),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "pukul " +
                                        DateFormat("hh:mm")
                                            .format(eachOrderData.dateTime!),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),

                              Spacer(),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Total Pembelian",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    (formatter
                                        .format(eachOrderData.totalAmount)
                                        .replaceAll(",00", "")),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Color(0xff575fcf),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Image(
                      image: AssetImage("images/icon-kardus-trisakti.png"),
                      width: 130,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Belum ada pesanan baru nih",
                      style: TextStyle(
                        color: Color(0xffbdc3c7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
