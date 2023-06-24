import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/models/ad.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/models/product.dart';
import 'package:afriprize/core/data/models/raffle_ticket.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DashboardViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  int selectedIndex = 0;
  final log = getLogger("DashboardViewModel");
  List<Product> productList = [];
  List<Product> sellingFast = [];
  List<Product> ads = [];

  void addToCart(Product product) {
    CartItem cartItem = CartItem(product: product, quantity: 1);
    cart.value.add(cartItem);
    locator<SnackbarService>().showSnackbar(message: "Product added to cart");
    cart.notifyListeners();
  }

  void changeSelected(int i) {
    selectedIndex = i;
    rebuildUi();
  }

  void init() {
    getAds();
    getProducts();
    getSellingFast();
    getResourceList();
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
        ads = (res.data["products"] as List)
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
      // ApiResponse res = await repo.getSellingFast();
      ApiResponse res = await repo.getProducts();

      if (res.statusCode == 200) {
        sellingFast = (res.data["products"] as List)
            .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    }

    setBusyForObject(sellingFast, false);
  }
}
