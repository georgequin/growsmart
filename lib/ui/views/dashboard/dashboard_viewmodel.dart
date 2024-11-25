import 'dart:convert';

import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/models/product.dart';
import 'package:afriprize/core/data/models/raffle_cart_item.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/core/utils/local_store_dir.dart';
import 'package:afriprize/core/utils/local_stotage.dart';
import 'package:afriprize/state.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../core/data/models/category.dart';
import '../../../core/data/models/project.dart';

class DashboardViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  int selectedIndex = 0;
  final log = getLogger("DashboardViewModel");
  List<Ads> adsList = [];
  List<Product> productList = [];
  List<Product> filteredProductList = [];
  List<Category> filteredCategories = [];
  List<Category> filteredCategoriesList = [];
  List<Category> categories = [];

  static const int allCategoriesId = 0;

  int selectedId = allCategoriesId;

  bool? onboarded;

  bool appBarLoading = false;
  final snackBar = locator<SnackbarService>();

  void setSelectedCategory(int id) {
    selectedId = id;

    if (id == allCategoriesId) {
      filteredProductList = productList;
    } else {
      print('id is: $id');
      filteredProductList = productList.where((product) {
        return product.categoryId == id;
      }).toList();
    }

    notifyListeners();
  }

  void changeSelected(int i) {
    selectedIndex = i;
    rebuildUi();
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }


  void initialise() {
    print('called initialize');
    init();
  }

  Future<void> init() async {
    setBusy(true);

    notifyListeners();
    await loadProduct();
    await loadCategories();
    notifyListeners();
    // await loadAds();

    if (userLoggedIn.value == true) {
      initCart();
      // await getNotifications();
      // await getProfile();
    }
    setBusy(false);
    notifyListeners();
  }



  Future<void> loadProduct() async {
    print('loading products....');
    try {


      dynamic storedJsonProduct = await locator<LocalStorage>().fetch(LocalStorageDir.product);
      log.i("Loaded jsonProducts from storage: $storedJsonProduct");




      if ( storedJsonProduct != null && storedJsonProduct.isNotEmpty) {
        log.i("Loaded decoded jsonProducts from storage: ${jsonDecode(storedJsonProduct)}");
        List<dynamic> storedProducts = jsonDecode(storedJsonProduct);
        log.i("Loaded Products from storage: $storedProducts");
        // Populate productList and filteredProductList
        productList = storedProducts
            .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        filteredProductList = productList;

        // Immediately notify UI to display data
        notifyListeners();
      }else{
        print('no value to load');
      }

      // Make API call in the background
      getProducts();
    } catch (e) {
      log.e("Error loading products: $e");
    }
  }


  Future<void> refreshData() async {
    setBusy(true);
    notifyListeners();
    getResourceList();
    setBusy(false);
    notifyListeners();
  }

  void getResourceList() {
    getProducts();
    getCategories();

    if (userLoggedIn.value == true) {
      initCart();
    }
  }

  Future<void> getProducts() async {
    print('getting online products');
    try {
      ApiResponse res = await repo.getProducts();

      if (res.statusCode == 200) {
        // Fetch updated products from API
        List<Product> updatedProductList = (res.data["products"] as List)
            .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        // Update the product list
        productList = updatedProductList;
        filteredProductList = productList;

        // Save updated data to local storage
        List<Map<String, dynamic>> storedProducts =
        productList.map((e) => e.toJson()).toList();
        await locator<LocalStorage>().save(LocalStorageDir.product, jsonEncode(storedProducts));

        log.i("Updated Products from API saved to storage.");

        // Notify UI about updated data
        notifyListeners();
      } else {
        log.e("API Error: ${res.data["message"]}");
      }
    } catch (e) {
      log.e("Error fetching products: $e");
    }
  }


  Future<void> loadCategories() async {
    dynamic storedDonations = await locator<LocalStorage>()
        .fetch(LocalStorageDir.donationsCategories);
    if (storedDonations != null) {
      categories = List<Map<String, dynamic>>.from(storedDonations)
          .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      // Add the "All Categories" option
      filteredCategories = [
        Category(id: 0, name: 'All', status: CategoryStatus.active),
        ...categories,
      ];
      notifyListeners();
    }
    getCategories();
    notifyListeners();
  }

  Future<void> getCategories() async {
    setBusy(true);
    notifyListeners();
    try {
      ApiResponse res = await repo.getCategories();
      if (res.statusCode == 200) {
        if (res.data != null && res.data["categories"] != null) {
          // Extract categories from the response
          categories = (res.data["categories"] as List)
              .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          // Save the categories locally
          List<Map<String, dynamic>> storedCategories =
              categories.map((e) => e.toJson()).toList();
          locator<LocalStorage>()
              .save(LocalStorageDir.donationsCategories, storedCategories);

          // Apply any filtering logic if needed
          filteredCategories = [
            Category(id: 0, name: 'All', status: CategoryStatus.active),
            ...categories,
          ];
        }
        rebuildUi();
      }
    } catch (e) {
      print(e);
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  void addToRaffleCart(Product raffle) async {
    // setBusy(true);
    // notifyListeners();
    try {
      final existingItem = raffleCart.value.firstWhere(
        (raffleItem) => raffleItem.raffle?.id == raffle.id,
        orElse: () => RaffleCartItem(raffle: raffle, quantity: 0),
      );

      if (existingItem.quantity != null &&
          existingItem.quantity! > 0 &&
          existingItem.raffle != null) {
        existingItem.quantity = (existingItem.quantity! + 1);
      } else {
        existingItem.quantity = 1;
        raffleCart.value.add(existingItem);
      }

      // Save to local storage
      List<Map<String, dynamic>> storedList =
          raffleCart.value.map((e) => e.toJson()).toList();
      await locator<LocalStorage>()
          .save(LocalStorageDir.raffleCart, storedList);

      // Save to online cart using API
      final response = await repo.addToCart({
        "productId": raffle.id,
        "quantity": existingItem.quantity,
      });

      if (response.statusCode == 200) {
        locator<SnackbarService>().showSnackbar(
            message: "Raffle added to cart", duration: Duration(seconds: 2));
        notifyListeners();
      } else {
        locator<SnackbarService>().showSnackbar(
            message: response.data["message"], duration: Duration(seconds: 2));
      }
    } catch (e) {
      locator<SnackbarService>().showSnackbar(
          message: "Failed to add raffle to cart: $e",
          duration: Duration(seconds: 2));
    }
  }

  void initCart() async {
    dynamic cart = await locator<LocalStorage>().fetch(LocalStorageDir.cart);
   if(cart != null){
     List<RaffleCartItem> localRaffleCart =
     List<Map<String, dynamic>>.from(cart)
         .map((e) => RaffleCartItem.fromJson(Map<String, dynamic>.from(e)))
         .toList();
     raffleCart.value = localRaffleCart;
     raffleCart.notifyListeners();
   }

  }

  Future<void> decreaseRaffleQuantity(RaffleCartItem item) async {
    try {
      if (item.quantity! > 1) {
        item.quantity = item.quantity! - 1;

        // Update online cart
        await repo.addToCart({
          "productId": item.raffle?.id,
          "quantity": item.quantity,
        });
      } else if (item.quantity! == 1) {
        // Remove from local cart
        raffleCart.value
            .removeWhere((cartItem) => cartItem.raffle?.id == item.raffle?.id);

        // Remove from online cart
        await repo.deleteFromCart(item.raffle!.id!);
      }

      // Save to local storage
      List<Map<String, dynamic>> storedList =
          raffleCart.value.map((e) => e.toJson()).toList();
      await locator<LocalStorage>()
          .save(LocalStorageDir.raffleCart, storedList);
    } catch (e) {
      locator<SnackbarService>().showSnackbar(
          message: "Failed to decrease raffle quantity: $e",
          duration: Duration(seconds: 2));
      print(e);
    }
  }

  Future<void> increaseRaffleQuantity(RaffleCartItem item) async {
    try {
      item.quantity = item.quantity! + 1;
      int index = raffleCart.value
          .indexWhere((raffleItem) => raffleItem.raffle?.id == item.raffle?.id);
      if (index != -1) {
        raffleCart.value[index] = item;
        raffleCart.value = List.from(raffleCart.value);

        // Update online cart
        await repo.addToCart({
          "productId": item.raffle?.id,
          "quantity": item.quantity,
        });

        // Save to local storage
        List<Map<String, dynamic>> storedList =
            raffleCart.value.map((e) => e.toJson()).toList();
        await locator<LocalStorage>()
            .save(LocalStorageDir.raffleCart, storedList);
      }
    } catch (e) {
      locator<SnackbarService>().showSnackbar(
          message: "Failed to increase raffle quantity: $e",
          duration: Duration(seconds: 2));
    } finally {
      raffleCart.notifyListeners();
    }
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
