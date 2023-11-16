import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:store_app/api_connection/api_connection.dart';
import 'package:store_app/users/model/order.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/users/order/order_details.dart';
import 'package:store_app/users/userPreferences/current_user.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class OrderFragmentScreen extends StatefulWidget {
  @override
  State<OrderFragmentScreen> createState() => _OrderFragmentScreenState();
}

class _OrderFragmentScreenState extends State<OrderFragmentScreen> {
  final currentOnlineUser = Get.put(CurrentUser());
  NumberFormat formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
  );

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }

  Future<List<Order>> getCurrentUserOrdersList() async {
    List<Order> ordersListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readOrders), body: {
        "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserOrdersList = jsonDecode(res.body);

        if (responseBodyOfCurrentUserOrdersList['success'] == true) {
          (responseBodyOfCurrentUserOrdersList['currentUserOrdersData'] as List)
              .forEach((eachCurrentUserOrderData) {
            ordersListOfCurrentUser
                .add(Order.fromJson(eachCurrentUserOrderData));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
    }

    return ordersListOfCurrentUser;
  }

  Future<List<Order>> getCurrentUserReceivedOrdersList() async {
    List<Order> ordersListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readHistory), body: {
        "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserOrdersList = jsonDecode(res.body);

        if (responseBodyOfCurrentUserOrdersList['success'] == true) {
          (responseBodyOfCurrentUserOrdersList['currentUserOrdersData'] as List)
              .forEach((eachCurrentUserOrderData) {
            ordersListOfCurrentUser
                .add(Order.fromJson(eachCurrentUserOrderData));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
    }

    return ordersListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Pesanan Saya',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Text("Diproses"),
              ),
              Tab(
                icon: Text("Selesai"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            displayOrdersList(context),
            displayReceivedOrdersList(context),
          ],
        ),
      ),
    );
  }

  //diproses
  displayOrdersList(context) {
    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      animSpeedFactor: 4,
      color: Color(0xff6b83bc),
      showChildOpacityTransition: false,
      child: FutureBuilder(
        future: getCurrentUserOrdersList(),
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
                      Get.to(
                          OrderDetailsScreen(clickedOrderInfo: eachOrderData));
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
                                  color: Color(0xfffff59D),
                                  borderRadius: BorderRadius.circular(5),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "Diproses",
                                      style: TextStyle(
                                          color: Colors.orange,
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
                        "Menu kosong nih",
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
      ),
    );
  }

  //selesai
  displayReceivedOrdersList(context) {
    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      animSpeedFactor: 4,
      color: Color(0xff6b83bc),
      showChildOpacityTransition: false,
      child: FutureBuilder(
        future: getCurrentUserReceivedOrdersList(),
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
                      Get.to(
                          OrderDetailsScreen(clickedOrderInfo: eachOrderData));
                    },
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                            child: Text(
                              "Selesai",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            color: Color(0xff6b83bc),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              DateFormat("hh:mm").format(
                                                  eachOrderData.dateTime!),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Spacer(),

                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                      ],
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
                        "Menu kosong nih",
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
      ),
    );
  }
}
