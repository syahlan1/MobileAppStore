import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/users/cart/cart_list_screen.dart';
import 'package:store_app/users/controllers/item_details_controller.dart';
import 'package:store_app/users/model/clothes.dart';
import 'package:store_app/users/userPreferences/current_user.dart';
import 'package:intl/intl.dart';
import '../../api_connection/api_connection.dart';
import 'package:photo_view/photo_view.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Clothes? itemInfo;

  ItemDetailsScreen({
    this.itemInfo,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final itemDetailsController = Get.put(ItemDetailsController());
  final currentOnlineUser = Get.put(CurrentUser());
  NumberFormat formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
  );

  addItemToCart() async {
    try {
      var res = await http.post(
        Uri.parse(API.addToCart),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.itemInfo!.item_id.toString(),
          "quantity": itemDetailsController.quantity.toString(),
          "color": widget.itemInfo!.colors![itemDetailsController.color],
          "size": widget.itemInfo!.sizes![itemDetailsController.size],
        },
      );

      if (res.statusCode ==
          200) //from flutter app the connection with api to server - success
      {
        var resBodyOfAddCart = jsonDecode(res.body);
        if (resBodyOfAddCart['success'] == true) {
          Fluttertoast.showToast(msg: "item saved to Cart Successfully.");
        } else {
          Fluttertoast.showToast(
              msg: "Error Occur. Item not saved to Cart and Try Again.");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
  }

  validateFavoriteList() async {
    try {
      var res = await http.post(
        Uri.parse(API.validateFavorite),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.itemInfo!.item_id.toString(),
        },
      );

      if (res.statusCode ==
          200) //from flutter app the connection with api to server - success
      {
        var resBodyOfValidateFavorite = jsonDecode(res.body);
        if (resBodyOfValidateFavorite['favoriteFound'] == true) {
          itemDetailsController.setIsFavorite(true);
        } else {
          itemDetailsController.setIsFavorite(false);
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
  }

  addItemToFavoriteList() async {
    try {
      var res = await http.post(
        Uri.parse(API.addFavorite),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.itemInfo!.item_id.toString(),
        },
      );

      if (res.statusCode ==
          200) //from flutter app the connection with api to server - success
      {
        var resBodyOfAddFavorite = jsonDecode(res.body);
        if (resBodyOfAddFavorite['success'] == true) {
          Fluttertoast.showToast(
              msg: "item saved to your Favorite List Successfully.");

          validateFavoriteList();
        } else {
          Fluttertoast.showToast(msg: "Item not saved to your Favorite List.");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
  }

  deleteItemFromFavoriteList() async {
    try {
      var res = await http.post(
        Uri.parse(API.deleteFavorite),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.itemInfo!.item_id.toString(),
        },
      );

      if (res.statusCode ==
          200) //from flutter app the connection with api to server - success
      {
        var resBodyOfDeleteFavorite = jsonDecode(res.body);
        if (resBodyOfDeleteFavorite['success'] == true) {
          Fluttertoast.showToast(msg: "item Deleted from your Favorite List.");

          validateFavoriteList();
        } else {
          Fluttertoast.showToast(
              msg: "item NOT Deleted from your Favorite List.");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    validateFavoriteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //item image
          GestureDetector(
            child: FadeInImage(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              placeholder: const AssetImage("images/place_holder.png"),
              image: NetworkImage(
                widget.itemInfo!.image!,
              ),
              imageErrorBuilder: (context, error, stackTraceError) {
                return const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                  ),
                );
              },
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return DetailPicture(itemInfo: widget.itemInfo);
              }));
            },
          ),

          //item information
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          ),

          //3 buttons || back - favorite - shopping cart
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  //back
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(color: Colors.grey, blurRadius: 15.0)
                      ],
                    ),
                  ),

                  const Spacer(),

                  //favorite
                  Obx(() => IconButton(
                        onPressed: () {
                          if (itemDetailsController.isFavorite == true) {
                            //delete item from favorites
                            deleteItemFromFavoriteList();
                          } else {
                            //save item to user favorites
                            addItemToFavoriteList();
                          }
                        },
                        icon: Icon(
                          itemDetailsController.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(color: Colors.grey, blurRadius: 15.0)
                          ],
                        ),
                      )),

                  //shopping cart icon
                  IconButton(
                    onPressed: () {
                      Get.to(CartListScreen());
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(color: Colors.grey, blurRadius: 15.0)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  itemInfoWidget() {
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      width: MediaQuery.of(Get.context!).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 18,
            ),

            Center(
              child: Container(
                height: 8,
                width: 100,
                decoration: BoxDecoration(
                  color: Color(0xffecf0f1),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            //name
            Text(
              widget.itemInfo!.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xff2c3e50),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            //rating + rating num
            //tags
            //price
            //quantity item counter
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //rating + rating num
                //tags
                //price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //rating + rating num
                      Row(
                        children: [
                          //rating bar
                          RatingBar.builder(
                            initialRating: widget.itemInfo!.rating!,
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
                            itemSize: 20,
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          //rating num
                          Text(
                            "(" + widget.itemInfo!.rating.toString() + ")",
                            style: const TextStyle(
                              color: Color(0xff34495e),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      //tags
                      Text(
                        widget.itemInfo!.tags!
                            .toString()
                            .replaceAll("[", "")
                            .replaceAll("]", ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 16),

                      //price
                      Text(
                        (formatter.format(widget.itemInfo!.price))
                            .replaceAll(",00", ""),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                //quantity item counter
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //+
                      IconButton(
                        onPressed: () {
                          itemDetailsController.setQuantityItem(
                              itemDetailsController.quantity + 1);
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Color(0xfff6b93b),
                        ),
                      ),
                      Text(
                        itemDetailsController.quantity.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xff2c3e50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //-
                      IconButton(
                        onPressed: () {
                          if (itemDetailsController.quantity - 1 >= 1) {
                            itemDetailsController.setQuantityItem(
                                itemDetailsController.quantity - 1);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Quantity must be 1 or greater than 1");
                          }
                        },
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Color(0xfff6b93b),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //sizes
            const Text(
              "Size:",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xff2c3e50),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.itemInfo!.sizes!.length, (index) {
                return Obx(
                  () => GestureDetector(
                    onTap: () {
                      itemDetailsController.setSizeItem(index);
                    },
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: itemDetailsController.size == index
                              ? Color(0xff575fcf)
                              : Color(0xff34495e),
                        ),
                        borderRadius: BorderRadius.circular(7),
                        color: itemDetailsController.size == index
                            ? Color(0xff575fcf).withOpacity(0.1)
                            : Colors.white,
                      ),
                      child: Text(
                        widget.itemInfo!.sizes![index]
                            .replaceAll("[", "")
                            .replaceAll("]", ""),
                        style: TextStyle(
                          fontSize: 16,
                          color: itemDetailsController.size == index
                              ? Color(0xff575fcf)
                              : Color(0xff34495e),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            //colors
            const Text(
              "Color:",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xff2c3e50),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.itemInfo!.colors!.length, (index) {
                return Obx(
                  () => GestureDetector(
                    onTap: () {
                      itemDetailsController.setColorItem(index);
                    },
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: itemDetailsController.color == index
                              ? Color(0xff575fcf)
                              : Color(0xff34495e),
                        ),
                        borderRadius: BorderRadius.circular(7),
                        color: itemDetailsController.color == index
                            ? Color(0xff575fcf).withOpacity(0.1)
                            : Colors.white,
                      ),
                      child: Text(
                        widget.itemInfo!.colors![index]
                            .replaceAll("[", "")
                            .replaceAll("]", ""),
                        style: TextStyle(
                          fontSize: 16,
                          color: itemDetailsController.color == index
                              ? Color(0xff575fcf)
                              : Color(0xff34495e),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            //description
            const Text(
              "Description:",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xff2c3e50),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.itemInfo!.description!,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            //add to cart button
            Material(
              elevation: 4,
              color: Color(0xff575fcf),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  addItemToCart();
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class DetailPicture extends StatelessWidget {
  final Clothes? itemInfo;

  DetailPicture({
    this.itemInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        child: Center(
          child: PhotoView(
            imageProvider: NetworkImage(
              itemInfo!.image!,
            ),
            minScale: PhotoViewComputedScale.contained * 1,
            maxScale: PhotoViewComputedScale.covered * 2,
          ),
        ),
      ),
    );
  }
}
