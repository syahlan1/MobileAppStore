import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:store_app/api_connection/api_connection.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/users/cart/cart_list_screen.dart';
import 'package:store_app/users/item/item_details_screen.dart';
import 'package:store_app/users/model/clothes.dart';
import 'package:store_app/users/model/favorite.dart';
import 'package:store_app/users/userPreferences/current_user.dart';
import 'package:intl/intl.dart';

class FavoritesFragmentScreen extends StatefulWidget {
  @override
  State<FavoritesFragmentScreen> createState() =>
      _FavoritesFragmentScreenState();
}

class _FavoritesFragmentScreenState extends State<FavoritesFragmentScreen> {
  final currentOnlineUser = Get.put(CurrentUser());

  NumberFormat formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
  );

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      favoriteListDesignWidget(context);
    });
  }

  Future<List<Favorite>> getCurrentUserFavoriteList() async {
    List<Favorite> favoriteListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readFavorite), body: {
        "user_id": currentOnlineUser.user.user_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserFavoriteListItems = jsonDecode(res.body);

        if (responseBodyOfCurrentUserFavoriteListItems['success'] == true) {
          (responseBodyOfCurrentUserFavoriteListItems['currentUserFavoriteData']
                  as List)
              .forEach((eachCurrentUserFavoriteItemData) {
            favoriteListOfCurrentUser
                .add(Favorite.fromJson(eachCurrentUserFavoriteItemData));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
    }

    return favoriteListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Favorites',
          style: TextStyle(
            fontSize: 24,
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        animSpeedFactor: 4,
        color: Color(0xff6b83bc),
        showChildOpacityTransition: false,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),

              //displaying favorite list
              favoriteListDesignWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  favoriteListDesignWidget(context) {
    return FutureBuilder(
        future: getCurrentUserFavoriteList(),
        builder: (context, AsyncSnapshot<List<Favorite>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapShot.data == null) {
            return const Center(
              child: Text(
                "No favorite item found",
                style: TextStyle(
                  color: Colors.grey,
                ),
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
                Favorite eachFavoriteItemRecord = dataSnapShot.data![index];

                Clothes clickedClothItems = Clothes(
                  item_id: eachFavoriteItemRecord.item_id,
                  colors: eachFavoriteItemRecord.colors,
                  image: eachFavoriteItemRecord.image,
                  name: eachFavoriteItemRecord.name,
                  price: eachFavoriteItemRecord.price,
                  rating: eachFavoriteItemRecord.rating,
                  sizes: eachFavoriteItemRecord.sizes,
                  description: eachFavoriteItemRecord.description,
                  tags: eachFavoriteItemRecord.tags,
                );

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  elevation: 0.0,
                  margin: EdgeInsets.fromLTRB(
                    index == 0 ? 8 : 4,
                    5,
                    index == dataSnapShot.data!.length - 1 ? 8 : 4,
                    5,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Get.to(ItemDetailsScreen(itemInfo: clickedClothItems));
                    },
                    child: Container(
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
                                eachFavoriteItemRecord.image!,
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
                                    //name and price1
                                    Expanded(
                                      child: Text(
                                        eachFavoriteItemRecord.name!,
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
                                            eachFavoriteItemRecord.tags
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
                                                eachFavoriteItemRecord.price)
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
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
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
        });
  }
}
