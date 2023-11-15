import 'dart:convert';

import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/models/ad.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/models/product.dart';
import 'package:afriprize/core/data/models/raffle_ticket.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/core/utils/local_store_dir.dart';
import 'package:afriprize/core/utils/local_stotage.dart';
import 'package:afriprize/state.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/data/models/app_notification.dart';

class DashboardViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  int selectedIndex = 0;
  final log = getLogger("DashboardViewModel");
  List<Product> productList = [];
  List<Product> sellingFast = [];
  List<Product> ads = [];



  void changeSelected(int i) {
    selectedIndex = i;
    rebuildUi();
  }

  void init() {
    getAds();
    getProducts();
    getSellingFast();
    if (userLoggedIn.value == true) {
      initCart();
      getNotifications();
    }
    // getResourceList();

    if (isFirstLaunch.value) {
      // showDialog(
      //   context: StackedService.navigatorKey!.currentState!.context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text('Popup Ad'),
      //       content: Container(
      //         width: double.maxFinite,
      //         height: 300,
      //         child: Image.network(popupImageUrl),
      //       ),
      //       actions: [
      //         TextButton(
      //           child: const Text('Close'),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         ),
      //       ],
      //     );
      //   });
    }

    isFirstLaunch.value = false;
    isFirstLaunch.notifyListeners();
  }

  void getResourceList() async {
    try {
      ApiResponse res = await repo.getResourceList();
    } catch (e) {
      log.e(e);
    }
  }

  void getAds() async {
    setBusyForObject(ads, true);

    try {
      ApiResponse res = await repo.getAds();
      if (res.statusCode == 200) {
        ads = (res.data["raffle"] as List)
            .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    }

    setBusyForObject(ads, false);
  }

  void getProducts() async {
    setBusyForObject(productList, true);

    try {
      ApiResponse res = await repo.getProducts();
      if (res.statusCode == 200) {
        productList = (res.data["products"] as List)
            .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    }

    setBusyForObject(productList, false);
  }

  void getSellingFast() async {
    setBusyForObject(sellingFast, true);

    try {
      ApiResponse res = await repo.getSellingFast();
      // ApiResponse res = await repo.getProducts();

      if (res.statusCode == 200) {
        sellingFast = (res.data["sellingfast"] as List)
            .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    }
    setBusyForObject(sellingFast, false);
  }

  void getNotifications() async {
    try {
      ApiResponse res = await repo.getNotifications(profile.value.id!);
      if (res.statusCode == 200) {
        notifications.value = (res.data["events"] as List)
            .map((e) => AppNotification.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      log.e(e);
    }
  }

  void addToCart(Product product) async {

    final existingItem = cart.value.firstWhere(
          (cartItem) => cartItem.product?.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity != null && existingItem.quantity! > 0 && existingItem.product != null) {
      // If the item exists, increase its quantity
      existingItem.quantity = (existingItem.quantity! + 1);
    } else {
      // If the item is not in the cart, add it as a new item
      existingItem.quantity = 1;
      cart.value.add(existingItem);

    }

    List<Map<String, dynamic>> storedList =
    cart.value.map((e) => e.toJson()).toList();
    await locator<LocalStorage>()
        .save(LocalStorageDir.cart, storedList);
    locator<SnackbarService>().showSnackbar(message: "Product added to cart");
    cart.notifyListeners();
  }

  void initCart() async {
    dynamic store = await locator<LocalStorage>().fetch(LocalStorageDir.cart);
    List<CartItem> localCart = List<Map<String, dynamic>>.from(store)
        .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    cart.value = localCart;
  }

  bool isProductInCart(Product product) {
    return cart.value.any((CartItem item) => item.product?.id == product.id);
  }

  Future<void> decreaseQuantity(CartItem item) async {
    if (item.quantity! > 1) {
      // Decrease the item's quantity by 1
      item.quantity = item.quantity! - 1;
    } else if (item.quantity! == 1) {
      // Remove the item from the cart if its quantity is 1
      cart.value.removeWhere((cartItem) => cartItem.product?.id == item.product?.id);
      // No need to set item.quantity to 0 since we're removing it
    }

    // Notify listeners and save the updated cart list to local storage
    cart.notifyListeners();
    List<Map<String, dynamic>> storedList = cart.value.map((e) => e.toJson()).toList();
    await locator<LocalStorage>().save(LocalStorageDir.cart, storedList);
  }

  Future<void> increaseQuantity(CartItem item) async {
    // Check if the item's quantity is greater than 1 before decreasing

      item.quantity = item.quantity! +1;

      // After modifying the cart item, replace the old cart item with the updated one
      int index = cart.value.indexWhere((cartItem) => cartItem.product?.id == item.product?.id);
      if (index != -1) {
        cart.value[index] = item;
        cart.value = List.from(cart.value);
        cart.notifyListeners();

        // Save the updated cart list to local storage
        List<Map<String, dynamic>> storedList = cart.value.map((e) => e.toJson()).toList();
        await locator<LocalStorage>().save(LocalStorageDir.cart, storedList);
      }
  }
}
