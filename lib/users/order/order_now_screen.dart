import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:store_app/users/controllers/cart_list_controller.dart';
import 'package:store_app/users/controllers/order_now_controller.dart';
import 'package:intl/intl.dart';
import 'package:store_app/users/order/order_confirmation.dart';

class OrderNowScreen extends StatelessWidget {
  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final double? totalAmount;
  final List<int>? selectedCartIDs;
  NumberFormat formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
  );

  OrderNowController orderNowController = Get.put(OrderNowController());
  List<String> deliverySystemNameList = ["JNE", "J&T", "Kargo"];

  List<String> paymentSystemNameList = ["BCA", "BNI", "BRI"];

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController shipmentAddressController = TextEditingController();
  TextEditingController noteToSellerController = TextEditingController();

  OrderNowScreen({
    this.selectedCartListItemsInfo,
    this.totalAmount,
    this.selectedCartIDs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Pemesanan",
        ),
        titleSpacing: 0,
      ),
      body: ListView(
        children: [
          //display selected items from cart list
          displaySelectedItemsFromUserCart(),

          const SizedBox(
            height: 30,
          ),

          //delivery system
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Jenis Pengiriman:",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xff2c3e50),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(18.0),
            child: Column(
              children: deliverySystemNameList.map((deliverySystemName) {
                return Obx(() => RadioListTile(
                      tileColor: Colors.white,
                      dense: true,
                      activeColor: Color(0xff575fcf),
                      title: Text(
                        deliverySystemName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      value: deliverySystemName,
                      groupValue: orderNowController.deliverySys,
                      onChanged: (newDeliverySystemValue) {
                        orderNowController
                            .setDelverySystem(newDeliverySystemValue!);
                      },
                    ));
              }).toList(),
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          //payment system
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sistem Pembayaran:",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff2c3e50),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "Company Account Number / ID: Y876-HFG7-CVBN-FN3N",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff2c3e50),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(18.0),
            child: Column(
              children: paymentSystemNameList.map((paymentSystemName) {
                return Obx(() => RadioListTile(
                      tileColor: Colors.white,
                      dense: true,
                      activeColor: Color(0xff575fcf),
                      title: Text(
                        paymentSystemName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      value: paymentSystemName,
                      groupValue: orderNowController.paymentSys,
                      onChanged: (newPaymentSystemValue) {
                        orderNowController
                            .setPaymentSystem(newPaymentSystemValue!);
                      },
                    ));
              }).toList(),
            ),
          ),

          //phone number
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Nomor telepon:",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xff2c3e50),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(
                color: Colors.black,
              ),
              controller: phoneNumberController,
              decoration: InputDecoration(
                hintText: 'Nomor telepon kamu..',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xff34495e),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xff34495e),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          //shipment address
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Alamat Pengiriman:",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xff2c3e50),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(
                color: Colors.black,
              ),
              controller: shipmentAddressController,
              decoration: InputDecoration(
                hintText: 'Alamat kamu..',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xff34495e),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xff34495e),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          //note to seller
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Catatan ke penjual:",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xff2c3e50),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(
                color: Colors.black,
              ),
              controller: noteToSellerController,
              decoration: InputDecoration(
                hintText: 'Catatan buat penjual..',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xff34495e),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xff34495e),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 30,
          ),

          const SizedBox(
            height: 30,
          ),
        ],
      ),
      bottomNavigationBar: //pay amount now button
          SizedBox(
        height: 60,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -3),
                color: Color(0xffecf0f1),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  (formatter.format(totalAmount!).replaceAll(",00", "")),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Material(
                  color: Color(0xff575fcf),
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: () {
                      if (phoneNumberController.text.isNotEmpty &&
                          shipmentAddressController.text.isNotEmpty) {
                        Get.to(OrderConfirmationScreen(
                          selectedCartIDs: selectedCartIDs,
                          selectedCartListItemsInfo: selectedCartListItemsInfo,
                          totalAmount: totalAmount,
                          deliverySystem: orderNowController.deliverySys,
                          paymentSystem: orderNowController.paymentSys,
                          phoneNumber: phoneNumberController.text,
                          shipmentAddress: shipmentAddressController.text,
                          note: noteToSellerController.text,
                        ));
                      } else {
                        Fluttertoast.showToast(msg: "Please complete the form");
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      child: Text(
                        "Bayar Sekarang",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  displaySelectedItemsFromUserCart() {
    return Column(
      children: List.generate(selectedCartListItemsInfo!.length, (index) {
        Map<String, dynamic> eachSelectedItem =
            selectedCartListItemsInfo![index];

        return Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
              index == selectedCartListItemsInfo!.length - 1 ? 16 : 8),
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
                    eachSelectedItem["image"],
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
                        eachSelectedItem["name"],
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
                        eachSelectedItem["size"]
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "") +
                            "\n" +
                            eachSelectedItem["color"]
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
                            .format(eachSelectedItem["price"])
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
                                .format(eachSelectedItem["price"])
                                .replaceAll(",00", "")) +
                            " x " +
                            eachSelectedItem["quantity"].toString() +
                            " = " +
                            (formatter
                                .format(eachSelectedItem["totalAmount"])
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
                  "x" + eachSelectedItem["quantity"].toString(),
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
