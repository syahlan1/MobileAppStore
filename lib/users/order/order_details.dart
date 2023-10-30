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

  NumberFormat formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
  );

  updateParcelStatusForUI(String parcelReceived) {
    _status.value = parcelReceived;
  }

  showDialogForParcelConfirmation() async {
    if (widget.clickedOrderInfo!.status == "new") {
      var response = await Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Konfirmasi",
            style: TextStyle(
              color: Color(0xff2c3e50),
            ),
          ),
          content: Text(
            "Apakah Barang sudah kamu terima?",
            style: TextStyle(
              color: Color(0xff34495e),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Belum",
                style: TextStyle(
                  color: Color(0xff6b83bc),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: "yesConfirmed");
              },
              child: Material(
                color: Color(0xff6b83bc),
                borderRadius: BorderRadius.circular(5),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Sudah",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          DateFormat("dd MMMM, yyyy - hh:mm a")
              .format(widget.clickedOrderInfo!.dateTime!),
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
            child: Material(
              color: Color(0xffecf0f1),
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
                        "Diterima",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
                                color: Colors.green,
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
              showTitleText("Nomor Telepon: "),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo!.phoneNumber!),

              const SizedBox(
                height: 26,
              ),

              //shipment address
              showTitleText("Alamat Pengiriman: "),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo!.shipmentAddress!),

              const SizedBox(
                height: 26,
              ),

              //Delivery
              showTitleText("Pengiriman: "),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo!.deliverySystem!),

              const SizedBox(
                height: 26,
              ),

              //Payment
              showTitleText("Sistem Pembayaran: "),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo!.paymentSystem!),

              const SizedBox(
                height: 26,
              ),

              //note
              showTitleText("Catata untuk Penjual: "),
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
              showContentText((formatter
                  .format(widget.clickedOrderInfo!.totalAmount)
                  .replaceAll(",00", ""))),

              const SizedBox(
                height: 26,
              ),

              //payment proof
              showTitleText("Bukti Pembayaran/transaksi: "),
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
        color: Color(0xff2c3e50),
      ),
    );
  }

  Widget showContentText(String contentText) {
    return Text(
      contentText,
      style: TextStyle(
        fontSize: 15,
        color: Color(0xff34495e),
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
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
              index == clickedOrderItemsInfo!.length - 1 ? 16 : 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Row(
            children: [
              //image
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: FadeInImage(
                  height: 100,
                  width: 100,
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
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 5),

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

                      const SizedBox(height: 5),

                      //price
                      Text(
                        (formatter
                            .format(itemInfo["price"])
                            .replaceAll(",00", "")),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xff2c3e50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),
                      Text(
                        (formatter
                                .format(itemInfo["price"])
                                .replaceAll(",00", "")) +
                            " x " +
                            itemInfo["quantity"].toString() +
                            " = " +
                            (formatter
                                .format(itemInfo["totalAmount"])
                                .replaceAll(",00", "")),
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
                    color: Colors.black,
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
