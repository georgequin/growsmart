import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/models/product.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/core/utils/local_store_dir.dart';
import 'package:afriprize/core/utils/local_stotage.dart';
import 'package:afriprize/state.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/data/models/app_notification.dart';

class DashboardViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  bool _isDataLoaded = false;
  int selectedIndex = 0;
  final log = getLogger("DashboardViewModel");
  List<Product> productList = [];
  List<Product> sellingFast = [];
  List<Product> ads = [];

  void changeSelected(int i) {
    selectedIndex = i;
    rebuildUi();
  }

  Future<void> init() async {
    await loadAds();
    await loadProducts();

    await loadSellingFast();
    await loadNotifications();
    notifyListeners();
  }

  Future<void> loadAds() async {
    dynamic storedAds = await locator<LocalStorage>().fetch(LocalStorageDir.adverts);
    if (storedAds != null) {
      ads = List<Map<String, dynamic>>.from(storedAds)
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
          .toList();

    } else {

       getAds();
    }
  }

  Future<void> loadProducts() async {
    dynamic storedProducts = await locator<LocalStorage>().fetch(LocalStorageDir.product);
    if (storedProducts != null) {
      productList = List<Map<String, dynamic>>.from(storedProducts)
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
       getProducts();
    }
    notifyListeners();
  }

  Future<void> loadSellingFast() async {
    dynamic storedSellingFast = await locator<LocalStorage>().fetch(LocalStorageDir.sellingFast);
    if (storedSellingFast != null) {
      sellingFast = List<Map<String, dynamic>>.from(storedSellingFast)
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
       getSellingFast();
    }
    notifyListeners();
  }

  Future<void> loadNotifications() async {
    dynamic storedNotifications = await locator<LocalStorage>().fetch(LocalStorageDir.notification);
    if (storedNotifications != null) {
      notifications.value = List<Map<String, dynamic>>.from(storedNotifications)
          .map((e) => AppNotification.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
       getNotifications();
    }
    notifyListeners();
  }

  Future<void> refreshData() async {
    setBusy(true); // Use this to show loading indicator
    getResourceList();
    setBusy(false); // Reset loading indicator after data is refreshed
  }

  void getResourceList(){
    getAds();
    getProducts();
    getSellingFast();
    if (userLoggedIn.value == true) {
      initCart();
      getNotifications();
    }
  }

  void getAds() async {
    setBusyForObject(ads, true);
    try {
      ApiResponse res = await repo.getAds();
      if (res.statusCode == 200) {
        ads = (res.data["raffle"] as List).map((e) => Product.fromJson(Map<String, dynamic>.from(e))).toList();
        List<Map<String, dynamic>> storedAds = ads.map((e) => e.toJson()).toList();
        locator<LocalStorage>().save(LocalStorageDir.adverts, storedAds);
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
        List<Map<String, dynamic>> storedProducts = productList.map((e) => e.toJson()).toList();
        locator<LocalStorage>().save(LocalStorageDir.product, storedProducts);
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
        print('value of selling fast is: ${res.data}');
        sellingFast = (res.data["products"] as List)
            .map((e) => Product.fromJson(Map<String, dynamic>.from(e))).toList();

        List<Map<String, dynamic>> storedAds = sellingFast.map((e) => e.toJson()).toList();
        locator<LocalStorage>().save(LocalStorageDir.sellingFast, storedAds);
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

        List<Map<String, dynamic>> storedNotice = notifications.value.map((e) => e.toJson()).toList();
        locator<LocalStorage>().save(LocalStorageDir.notification, storedNotice);
      }
    } catch (e) {
      log.e(e);
    }
  }

  void addToCart(Product product) async {

    final existingItem = raffleCart.value.firstWhere(
          (cartItem) => cartItem.product?.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity != null && existingItem.quantity! > 0 && existingItem.product != null) {
      // If the item exists, increase its quantity
      existingItem.quantity = (existingItem.quantity! + 1);
    } else {
      // If the item is not in the cart, add it as a new item
      existingItem.quantity = 1;
      raffleCart.value.add(existingItem);

    }

    List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
    await locator<LocalStorage>()
        .save(LocalStorageDir.cart, storedList);
    locator<SnackbarService>().showSnackbar(message: "Product added to cart");
    raffleCart.notifyListeners();
  }

  void initCart() async {
    dynamic store = await locator<LocalStorage>().fetch(LocalStorageDir.cart);
    List<CartItem> localCart = List<Map<String, dynamic>>.from(store)
        .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    raffleCart.value = localCart;
  }

  bool isProductInCart(Product product) {
    return raffleCart.value.any((CartItem item) => item.product?.id == product.id);
  }

  Future<void> decreaseQuantity(CartItem item) async {
    if (item.quantity! > 1) {
      // Decrease the item's quantity by 1
      item.quantity = item.quantity! - 1;
    } else if (item.quantity! == 1) {
      // Remove the item from the cart if its quantity is 1
      raffleCart.value.removeWhere((cartItem) => cartItem.product?.id == item.product?.id);
      // No need to set item.quantity to 0 since we're removing it
    }

    // Notify listeners and save the updated cart list to local storage
    raffleCart.notifyListeners();
    List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
    await locator<LocalStorage>().save(LocalStorageDir.cart, storedList);
  }

  Future<void> increaseQuantity(CartItem item) async {
    // Check if the item's quantity is greater than 1 before decreasing

      item.quantity = item.quantity! +1;

      // After modifying the cart item, replace the old cart item with the updated one
      int index = raffleCart.value.indexWhere((cartItem) => cartItem.product?.id == item.product?.id);
      if (index != -1) {
        raffleCart.value[index] = item;
        raffleCart.value = List.from(raffleCart.value);
        raffleCart.notifyListeners();

        // Save the updated cart list to local storage
        List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
        await locator<LocalStorage>().save(LocalStorageDir.cart, storedList);
      }
  }

  bool isDrawDateSoon(DateTime drawDate) {
    final now = DateTime.now();
    return drawDate.difference(now).inDays <= 5;
  }

  bool isStockLow(int stockTotal, int verifiedSales) {
    return (stockTotal - verifiedSales) <= 10;
  }

  String formatRemainingTime(DateTime drawDate) {
    final now = DateTime.now();
    final difference = drawDate.difference(now);
    // Format the Duration to your needs
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void onEnd() {
    print('onEnd');
    //TODO SEND USER NOTIFICATION OF AVAILABILITY OF PRODUCT
    notifyListeners();
  }

}
