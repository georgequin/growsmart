import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/models/product.dart';
import 'package:afriprize/core/data/models/raffle_cart_item.dart';
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
import 'package:video_player/video_player.dart';

import '../../../core/data/models/app_notification.dart';

class DashboardViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  bool _isDataLoaded = false;
  int selectedIndex = 0;
  final log = getLogger("DashboardViewModel");
  List<Product> productList = [];
  List<Raffle> raffleList = [];
  List<Product> sellingFast = [];
  List<Raffle> featuredRaffle = [];

  void changeSelected(int i) {
    selectedIndex = i;
    rebuildUi();
  }

  late VideoPlayerController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initialise() {
    controller = VideoPlayerController.asset('assets/videos/dashboard.mp4')
      ..initialize().then((_) {
        controller.setLooping(true);
        controller.play();
        notifyListeners();
      }).onError((error, stackTrace) {
        // Handle the error here
      });
  }

  Future<void> init() async {
    await loadFeaturedRaffles();
    await loadRaffles();
    await loadProducts();

    await loadSellingFast();
    await loadNotifications();
    notifyListeners();
  }

  Future<void> loadFeaturedRaffles() async {
    dynamic storedFeaturedRaffles = await locator<LocalStorage>().fetch(LocalStorageDir.featuredRaffle);
    if (storedFeaturedRaffles != null) {
      featuredRaffle = List<Map<String, dynamic>>.from(storedFeaturedRaffles)
          .map((e) => Raffle.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      notifyListeners();
    } else {
       getFeaturedRaffles();
       notifyListeners();
    }
  }

  Future<void> loadRaffles() async {
    dynamic storedRaffle = await locator<LocalStorage>().fetch(LocalStorageDir.raffle);
    if (storedRaffle != null) {
      raffleList = List<Map<String, dynamic>>.from(storedRaffle)
          .map((e) => Raffle.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      notifyListeners();
    } else {
      getRaffles();
      notifyListeners();
    }
  }

  Future<void> loadProducts() async {
    dynamic storedProducts = await locator<LocalStorage>().fetch(LocalStorageDir.product);
    if (storedProducts != null) {
      productList = List<Map<String, dynamic>>.from(storedProducts)
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      notifyListeners();
    } else {
       getProducts();
       notifyListeners();
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
    getRaffles();
    getFeaturedRaffles();
    getProducts();
    getSellingFast();
    if (userLoggedIn.value == true) {
      initCart();
      getNotifications();
    }
  }

  void getFeaturedRaffles() async {
    setBusyForObject(featuredRaffle, true);
    try {
      ApiResponse res = await repo.getFeaturedRaffle();
      if (res.statusCode == 200) {
        featuredRaffle = (res.data["raffle"] as List).map((e) => Raffle.fromJson(Map<String, dynamic>.from(e))).toList();
        List<Map<String, dynamic>> storedRaffles = featuredRaffle.map((e) => e.toJson()).toList();
        locator<LocalStorage>().save(LocalStorageDir.featuredRaffle, storedRaffles);
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    }
    setBusyForObject(featuredRaffle, false);
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

  void getRaffles() async {
    setBusyForObject(raffleList, true);
    try {
      ApiResponse res = await repo.getRaffle();
      if (res.statusCode == 200) {
        raffleList = (res.data["raffle"] as List).map((e) => Raffle.fromJson(Map<String, dynamic>.from(e))).toList();
        List<Map<String, dynamic>> storedRaffles = raffleList.map((e) => e.toJson()).toList();
        locator<LocalStorage>().save(LocalStorageDir.raffle, storedRaffles);
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    }
    setBusyForObject(raffleList, false);
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

  void addToRaffleCart(Raffle raffle) async {
    final existingItem = raffleCart.value.firstWhere(
          (raffleItem) => raffleItem.raffle?.id == raffle.id,
      orElse: () => RaffleCartItem(raffle: raffle, quantity: 0),
    );

    if (existingItem.quantity != null && existingItem.quantity! > 0 && existingItem.raffle != null) {
      existingItem.quantity = (existingItem.quantity! + 1);
    } else {
      existingItem.quantity = 1;
      raffleCart.value.add(existingItem);
    }

    List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
    await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);
    locator<SnackbarService>().showSnackbar(message: "Raffle added to cart");
    raffleCart.notifyListeners();
  }

  void addToProductCart(Product product) async {
    final existingItem = shopCart.value.firstWhere(
          (cartItem) => cartItem.product?.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity != null && existingItem.quantity! > 0 && existingItem.product != null) {
      existingItem.quantity = (existingItem.quantity! + 1);
    } else {
      existingItem.quantity = 1;
      shopCart.value.add(existingItem);
    }

    List<Map<String, dynamic>> storedList = shopCart.value.map((e) => e.toJson()).toList();
    await locator<LocalStorage>()
        .save(LocalStorageDir.cart, storedList);
    locator<SnackbarService>().showSnackbar(message: "Product added to cart");
    shopCart.notifyListeners();
  }

  void initCart() async {
    dynamic raffle = await locator<LocalStorage>().fetch(LocalStorageDir.cart);
    dynamic store = await locator<LocalStorage>().fetch(LocalStorageDir.cart);
    List<RaffleCartItem> localRaffleCart = List<Map<String, dynamic>>.from(raffle)
        .map((e) => RaffleCartItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    List<CartItem> localShopCart = List<Map<String, dynamic>>.from(store)
        .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    raffleCart.value = localRaffleCart;
    shopCart.value = localShopCart;
    raffleCart.notifyListeners();
  }

  // bool isRaffleInCart(Product product) {
  //   return raffleCart.value.any((CartItem item) => item.product?.id == product.id);
  // }

  Future<void> decreaseQuantity(CartItem item) async {
    if (item.quantity! > 1) {
      // Decrease the item's quantity by 1
      item.quantity = item.quantity! - 1;
    } else if (item.quantity! == 1) {
      // Remove the item from the cart if its quantity is 1
      shopCart.value.removeWhere((cartItem) => cartItem.product?.id == item.product?.id);
      // No need to set item.quantity to 0 since we're removing it
    }

    // Notify listeners and save the updated cart list to local storage
    shopCart.notifyListeners();
    List<Map<String, dynamic>> storedList = shopCart.value.map((e) => e.toJson()).toList();
    await locator<LocalStorage>().save(LocalStorageDir.cart, storedList);
  }

  Future<void> decreaseRaffleQuantity(RaffleCartItem item) async {
    if (item.quantity! > 1) {
      item.quantity = item.quantity! - 1;
    } else if (item.quantity! == 1) {
      raffleCart.value.removeWhere((cartItem) => cartItem.raffle?.id == item.raffle?.id);
    }

    raffleCart.notifyListeners();
    List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
    await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);
  }

  Future<void> increaseQuantity(CartItem item) async {
      item.quantity = item.quantity! +1;
      int index = shopCart.value.indexWhere((cartItem) => cartItem.product?.id == item.product?.id);
      if (index != -1) {
        shopCart.value[index] = item;
        shopCart.value = List.from(shopCart.value);
        shopCart.notifyListeners();
        List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
        await locator<LocalStorage>().save(LocalStorageDir.cart, storedList);
      }
  }

  Future<void> increaseRaffleQuantity(RaffleCartItem item) async {
    item.quantity = item.quantity! +1;
    int index = raffleCart.value.indexWhere((raffleItem) => raffleItem.raffle?.id == item.raffle?.id);
    if (index != -1) {
      raffleCart.value[index] = item;
      raffleCart.value = List.from(raffleCart.value);
      raffleCart.notifyListeners();
      List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
      await locator<LocalStorage>().save(LocalStorageDir.raffle, storedList);
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
