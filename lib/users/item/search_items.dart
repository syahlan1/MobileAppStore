import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:store_app/api_connection/api_connection.dart';
import 'package:store_app/users/cart/cart_list_screen.dart';
import 'package:store_app/users/item/item_details_screen.dart';
import 'package:store_app/users/model/clothes.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SearchItems extends StatefulWidget {
  final String? typedKeyWords;

  SearchItems({this.typedKeyWords});
  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  TextEditingController searchController = TextEditingController();

  NumberFormat formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
  );

  Future<List<Clothes>> readSearchRecordFound() async {
    List<Clothes> clothesSearchList = [];

    if (searchController.text != "") {
      try {
        var res = await http.post(Uri.parse(API.searchItems), body: {
          "typedKeyWords": searchController.text,
        });

        if (res.statusCode == 200) {
          var responseBodyOfSearchItems = jsonDecode(res.body);

          if (responseBodyOfSearchItems['success'] == true) {
            (responseBodyOfSearchItems['itemsFoundData'] as List)
                .forEach((eachItemData) {
              clothesSearchList.add(Clothes.fromJson(eachItemData));
            });
          }
        } else {
          Fluttertoast.showToast(msg: "Status Code is not 200");
        }
      } catch (errorMsg) {
        Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
      }
    }
    return clothesSearchList;
  }

  @override
  void initState() {
    super.initState();

    searchController.text = widget.typedKeyWords!;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: showSearchBarWidget(),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(CartListScreen());
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Color(0xff2f3542),
            ),
          ),
        ],
      ),
      body: searchItemDesignWidget(context),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        style: const TextStyle(color: Colors.black),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(
              Icons.search,
              color: Color(0xff34495e),
            ),
          ),
          hintText: "Cari barang lainnya...",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              searchController.clear();
              setState(() {});
            },
            icon: const Icon(
              Icons.close,
              color: Color(0xff34495e),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Color(0xff6b83bc),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.black,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  searchItemDesignWidget(context) {
    return FutureBuilder(
        future: readSearchRecordFound(),
        builder: (context, AsyncSnapshot<List<Clothes>> dataSnapShot) {
          if (dataSnapShot.data!.length > 0) {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.64,
                  ),
                  itemCount: dataSnapShot.data!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Clothes eachClothItemRecord = dataSnapShot.data![index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      elevation: 0.0,
                      margin: EdgeInsets.fromLTRB(
                        index == 0 ? 16 : 8,
                        10,
                        index == dataSnapShot.data!.length - 1 ? 16 : 8,
                        10,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Get.to(
                              ItemDetailsScreen(itemInfo: eachClothItemRecord));
                        },
                        child: Container(
                          width: 185,
                          child: Column(
                            children: [
                              //image clothes
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                                child: FadeInImage(
                                  height: 150,
                                  width: 185,
                                  fit: BoxFit.cover,
                                  placeholder: const AssetImage(
                                      "images/place_holder.png"),
                                  image: NetworkImage(
                                    eachClothItemRecord.image!,
                                  ),
                                  imageErrorBuilder:
                                      (context, error, stackTraceError) {
                                    return const Center(
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              //name + price
                              //tags
                              Expanded(
                                child: Container(
                                  width: 180,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //name and price
                                        Expanded(
                                          child: Text(
                                            eachClothItemRecord.name!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),

                                        //tags
                                        Expanded(
                                          child: Text(
                                            "Tags: \n" +
                                                eachClothItemRecord.tags
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
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),

                                        //price
                                        Expanded(
                                          child: Text(
                                            formatter
                                                .format(
                                                    eachClothItemRecord.price)
                                                .replaceAll(",00", ""),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff575fcf),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
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
                        "Pencarian tidak ditemukan",
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
        });
  }
}
