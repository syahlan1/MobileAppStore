import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:store_app/api_connection/api_connection.dart';
import 'package:store_app/users/controllers/cart_list_controller.dart';
import 'package:store_app/users/model/cart.dart';
import 'package:store_app/users/model/clothes.dart';
import 'package:store_app/users/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;

class CartListScreen extends StatefulWidget {
  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  final currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());

  getCurrentUserCartList() async {
    List<Cart> cartListOfCurrentUser = [];

    try {
      var res = await http.post(
        Uri.parse(API.getCartList),
        body: {
          "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
        },
      );

      if (res.statusCode == 200) {
        var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);

        if (responseBodyOfGetCurrentUserCartItems['success'] == true) {
          (responseBodyOfGetCurrentUserCartItems['currentUserCartData'] as List)
              .forEach((eachCurrentUserCartItemData) {
            cartListOfCurrentUser
                .add(Cart.fromJson(eachCurrentUserCartItemData));
          });
        } else {
          Fluttertoast.showToast(msg: "no item found on your cart");
        }

        cartListController.setList(cartListOfCurrentUser);
      } else {
        Fluttertoast.showToast(msg: "Status code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
    }

    calculateTotalAmount();
  }

  calculateTotalAmount() {
    cartListController.setTotal(0);

    if (cartListController.selectedItemList.isNotEmpty) {
      cartListController.cartList.forEach((itemInCart) {
        if (cartListController.selectedItemList.contains(itemInCart.item_id)) {
          double eachItemTotalAmount = (itemInCart.price!) *
              (double.parse(itemInCart.quantity.toString()));
          cartListController
              .setTotal(cartListController.total + eachItemTotalAmount); //12
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Obx(
        () => cartListController.cartList.isNotEmpty
            ? ListView.builder(
                itemCount: cartListController.cartList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Cart cartModel = cartListController.cartList[index];

                  Clothes clothesModel = Clothes(
                    item_id: cartModel.cart_id,
                    colors: cartModel.colors,
                    image: cartModel.image,
                    name: cartModel.name,
                    price: cartModel.price,
                    rating: cartModel.rating,
                    sizes: cartModel.sizes,
                    description: cartModel.description,
                    tags: cartModel.tags,
                  );

                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        //check box
                        GetBuilder(
                          init: CartListController(),
                          builder: (c) {
                            return IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  cartListController.selectedItemList
                                          .contains(cartModel.item_id)
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: cartListController.isSelectedAll
                                      ? Colors.white
                                      : Colors.grey,
                                ));
                          },
                        ),

                        //name
                        //color size + price
                        //+ -
                        //image
                        Expanded(
                            child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                0,
                                index == 0 ? 16 : 8,
                                16,
                                index == cartListController.cartList.length - 1
                                    ? 16
                                    : 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.black,
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 6,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //name
                                        Text(
                                          clothesModel.name.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 20),

                                        //color size + price
                                        Row(
                                          children: [
                                            //color + size
                                            Expanded(
                                                child: Text(
                                              "Color: ${cartModel.color!.replaceAll('[', '').replaceAll(']', '')}\nSize: ${cartModel.size!.replaceAll('[', '').replaceAll(']', '')}",
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white60,
                                              ),
                                            )),

                                            //price
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 12, right: 12),
                                              child: Text(
                                                "Rp." +
                                                    clothesModel.price
                                                        .toString(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.purpleAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        //+ -
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            //-
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.grey,
                                                size: 30,
                                              ),
                                            ),

                                            const SizedBox(
                                              width: 10,
                                            ),

                                            Text(
                                              cartModel.quantity.toString(),
                                              style: const TextStyle(
                                                color: Colors.purpleAccent,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            const SizedBox(
                                              width: 10,
                                            ),

                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.grey,
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //image
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  child: FadeInImage(
                                    height: 180,
                                    width: 150,
                                    fit: BoxFit.cover,
                                    placeholder: const AssetImage(
                                        "images/place_holder.png"),
                                    image: NetworkImage(
                                      cartModel.image!,
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
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: Text("Cart is empty"),
              ),
      ),
    );
  }
}
