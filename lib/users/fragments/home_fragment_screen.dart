import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/api_connection/api_connection.dart';
import 'package:store_app/users/cart/cart_list_screen.dart';
import 'package:store_app/users/item/item_details_screen.dart';
import 'package:store_app/users/item/search_items.dart';
import 'package:store_app/users/model/clothes.dart';
import 'package:intl/intl.dart';

class HomeFragmentScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();
  NumberFormat formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
  );

  Future<List<Clothes>> getTrendingClothItems() async {
    List<Clothes> trendingClothItemsList = [];

    try {
      var res = await http.post(Uri.parse(API.getTrendingMostPopularClothes));

      if (res.statusCode == 200) {
        var responseBodyOfTrending = jsonDecode(res.body);
        if (responseBodyOfTrending["success"] == true) {
          (responseBodyOfTrending["clothItemsData"] as List)
              .forEach((eachRecord) {
            trendingClothItemsList.add(Clothes.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }

    return trendingClothItemsList;
  }

  Future<List<Clothes>> getAllClothItems() async {
    List<Clothes> allClothItemsList = [];

    try {
      var res = await http.post(Uri.parse(API.getAllClothes));

      if (res.statusCode == 200) {
        var responseBodyOfAllClothes = jsonDecode(res.body);
        if (responseBodyOfAllClothes["success"] == true) {
          (responseBodyOfAllClothes["clothItemsData"] as List)
              .forEach((eachRecord) {
            allClothItemsList.add(Clothes.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }

    return allClothItemsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          title: showSearchBarWidget(),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),

            const SizedBox(
              height: 24,
            ),

            //trending-popular items
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "Trending",
                style: TextStyle(
                  color: Color(0xff2f3542),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            trendingMostPopularClothItemWidget(context),

            const SizedBox(
              height: 20,
            ),

            //all new collections/items
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "New Collections",
                style: TextStyle(
                  color: Color(0xff2f3542),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),

            allItemWidget(context),
          ],
        ),
      ),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 20, 2, 15),
      child: TextField(
        style: const TextStyle(color: Colors.black),
        controller: searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffdfe4ea),
          prefixIcon: IconButton(
            onPressed: () {
              Get.to(SearchItems(typedKeyWords: searchController.text));
            },
            icon: const Icon(
              Icons.search,
              color: Color(0xff2f3542),
            ),
          ),
          hintText: "Cari barang yang kamu inginkan...",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              color: Color(0xfff1f2f6),
            ),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Color(0xff575fcf),
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

  Widget trendingMostPopularClothItemWidget(context) {
    return FutureBuilder(
      future: getTrendingClothItems(),
      builder: (context, AsyncSnapshot<List<Clothes>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null) {
          return const Center(
            child: Text(
              "No Trending item found",
            ),
          );
        }
        if (dataSnapShot.data!.length > 0) {
          return SizedBox(
            height: 260,
            child: ListView.builder(
              itemCount: dataSnapShot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Clothes eachClothItemRecord = dataSnapShot.data![index];
                Clothes eachClothItemData = dataSnapShot.data![index];
                return Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(
                    index == 0 ? 16 : 8,
                    10,
                    index == dataSnapShot.data!.length - 1 ? 16 : 8,
                    10,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Get.to(ItemDetailsScreen(itemInfo: eachClothItemRecord));
                    },
                    child: Container(
                      width: 200,
                      child: Column(
                        children: [
                          //item image
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: FadeInImage(
                              height: 150,
                              width: 200,
                              fit: BoxFit.cover,
                              placeholder:
                                  const AssetImage("images/place_holder.png"),
                              image: NetworkImage(
                                eachClothItemData.image!,
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

                          //item name & price
                          //rating stars & rating numbers
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //item name & price
                                Text(
                                  eachClothItemData.name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),

                                //rating stars & rating numbers
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: eachClothItemData.rating!,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemBuilder: (context, c) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (updateRating) {},
                                      ignoreGestures: true,
                                      unratedColor: Colors.grey,
                                      itemSize: 16,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "(" +
                                          eachClothItemData.rating.toString() +
                                          ")",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                Text(
                                  (formatter
                                      .format(eachClothItemData.price)
                                      .replaceAll(",00", "")),
                                  style: const TextStyle(
                                    color: Color(0xff575fcf),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text("Empty, No Data."),
          );
        }
      },
    );
  }

  allItemWidget(context) {
    return FutureBuilder(
        future: getAllClothItems(),
        builder: (context, AsyncSnapshot<List<Clothes>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapShot.data == null) {
            return const Center(
              child: Text(
                "No Trending item found",
              ),
            );
          }
          if (dataSnapShot.data!.length > 0) {
            return GridView.builder(
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
                      Get.to(ItemDetailsScreen(itemInfo: eachClothItemRecord));
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
                              placeholder:
                                  const AssetImage("images/place_holder.png"),
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            .format(eachClothItemRecord.price)
                                            .replaceAll(",00", ""),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff575fcf),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 16,
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
            );
          } else {
            return const Center(
              child: Text("Empty, No Data."),
            );
          }
        });
  }
}
