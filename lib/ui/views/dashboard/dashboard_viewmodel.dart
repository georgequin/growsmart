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

  void addToCart(Product product) async {
    CartItem cartItem = CartItem(product: product, quantity: 1);
    cart.value.add(cartItem);
    List<Map<String, dynamic>> storedList =
        cart.value.map((e) => e.toJson()).toList();
    await locator<LocalStorage>().save(LocalStorageDir.cart, storedList);
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
}
