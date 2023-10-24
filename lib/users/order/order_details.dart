import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app/api_connection/api_connection.dart';
import 'package:store_app/users/model/order.dart';
import 'package:http/http.dart' as http;

class OrderDetailsScreen extends StatefulWidget {
  final Order? clickedOrderInfo;

  OrderDetailsScreen({this.clickedOrderInfo});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  RxString _status = "new".obs;
  String get status => _status.value;

  updateParcelStatusForUI(String parcelReceived) {
    _status.value = parcelReceived;
  }

  showDialogForParcelConfirmation() async {
    if (widget.clickedOrderInfo!.status == "new") {
      var response = await Get.dialog(
        AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            "Confirmation",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          content: Text(
            "Have you received parcel?",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "No",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: "yesConfirmed");
              },
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      );

      if (response == "yesConfirmed") {
        updateStatusValueInDatabase();
      }
    }
  }

  updateStatusValueInDatabase() async {
    try {
      var response = await http.post(Uri.parse(API.updateStatus), body: {
        "order_id": widget.clickedOrderInfo!.order_id.toString(),
      });

      if (response.statusCode == 200) {
        var responseBodyOfUpdateStatus = jsonDecode(response.body);
        if (responseBodyOfUpdateStatus["success"] == true) {
          updateParcelStatusForUI("arrived");
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    updateParcelStatusForUI(widget.clickedOrderInfo!.status.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          DateFormat("dd MMMM, yyyy - hh:mm a")
              .format(widget.clickedOrderInfo!.dateTime!),
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
            child: Material(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  if (status == "new") {
                    showDialogForParcelConfirmation();
                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        "Received",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Obx(
                        () => status == "new"
                            ? Icon(Icons.help_outline, color: Colors.redAccent)
                            : Icon(
                                Icons.check_circle_outline,
                                color: Colors.greenAccent,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //display items belong to clicked order
              displayClickedOrderItems(),

              const SizedBox(
                height: 26,
              ),

              //phone number
              showTitleText("Phone Number: "),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo!.phoneNumber!),

              const SizedBox(
                height: 26,
              ),

              //shipment address
              showTitleText("Shipment Address: "),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo!.shipmentAddress!),

              const SizedBox(
                height: 26,
              ),

              //Delivery
              showTitleText("Delivery System: "),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo!.deliverySystem!),

              const SizedBox(
                height: 26,
              ),

              //Payment
              showTitleText("Payment System: "),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo!.paymentSystem!),

              const SizedBox(
                height: 26,
              ),

              //note
              showTitleText("Note to Seller: "),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo!.note!),

              const SizedBox(
                height: 26,
              ),

              //total amount
              showTitleText("Total Amount: "),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo!.totalAmount.toString()),

              const SizedBox(
                height: 26,
              ),

              //payment proof
              showTitleText("Proof of Payment/Transaction: "),
              const SizedBox(
                height: 8,
              ),
              FadeInImage(
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.fitWidth,
                placeholder: const AssetImage("images/place_holder.png"),
                image: NetworkImage(
                    API.hostImages + widget.clickedOrderInfo!.image!),
                imageErrorBuilder: (context, error, stackTraceError) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showTitleText(String titleText) {
    return Text(
      titleText,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.grey,
      ),
    );
  }

  Widget showContentText(String contentText) {
    return Text(
      contentText,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.white38,
      ),
    );
  }

  Widget displayClickedOrderItems() {
    List<String> clickedOrderItemsInfo =
        widget.clickedOrderInfo!.selectedItems!.split("||");

    return Column(
      children: List.generate(clickedOrderItemsInfo.length, (index) {
        Map<String, dynamic> itemInfo =
            jsonDecode(clickedOrderItemsInfo[index]);

        return Container(
          margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
              index == clickedOrderItemsInfo.length - 1 ? 16 : 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white24,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 6,
                color: Colors.black26,
              ),
            ],
          ),
          child: Row(
            children: [
              //image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: FadeInImage(
                  height: 130,
                  width: 130,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage("images/place_holder.png"),
                  image: NetworkImage(
                    itemInfo["image"],
                  ),
                  imageErrorBuilder: (context, error, stackTraceError) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                      ),
                    );
                  },
                ),
              ),

              //name
              //size
              //price
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //name
                      Text(
                        itemInfo["name"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      //size + color
                      Text(
                        itemInfo["size"]
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "") +
                            "\n" +
                            itemInfo["color"]
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 10),

                      //price
                      Text(
                        itemInfo["price"].toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        itemInfo["price"].toString() +
                            " x " +
                            itemInfo["quantity"].toString() +
                            " = " +
                            itemInfo["totalAmount"].toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //quantity
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "x" + itemInfo["quantity"].toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
