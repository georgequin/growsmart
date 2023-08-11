import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/data/models/order_info.dart';
import 'checkout.dart';

class CartViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final snackBar = locator<SnackbarService>();
  final log = getLogger("CartViewModel");
  List<CartItem> itemsToDelete = [];
  int subTotal = 0;
  int deliveryFee = 0;

  void addRemoveDelete(CartItem item) {
    itemsToDelete.contains(item)
        ? itemsToDelete.remove(item)
        : itemsToDelete.add(item);
    rebuildUi();
  }

  void clearCart() {
    for (var element in itemsToDelete) {
      cart.value.remove(element);
    }
    itemsToDelete.clear();
    cart.notifyListeners();
    rebuildUi();
    getSubTotal();
  }

  void getSubTotal() {
    int total = 0;

    for (var element in cart.value) {
      total = total + (element.product!.productPrice! * element.quantity!);
    }

    subTotal = total;
    rebuildUi();
  }

  void getDeliveryTotal() {
    int total = 0;

    for (var element in cart.value) {
      total = total + (element.product!.shippingFee!);
    }

    deliveryFee = total;
    rebuildUi();
  }

  void checkout() async {
    if (cart.value.isEmpty) {
      return null;
    }
    setBusy(true);
    try {
      ApiResponse res = await repo.saveOrder({
        "products": cart.value
            .map((e) => {"id": e.product!.id, "quantity": e.quantity})
            .toList(),
      });
      if (res.statusCode == 200) {
        List<OrderInfo> list = (res.data["orderDetails"] as List)
            .map((e) => OrderInfo.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        await locator<NavigationService>()
            .navigateToView(Checkout(
              infoList: list,
            ))!
            .whenComplete(() => rebuildUi());
      } else {
        snackBar.showSnackbar(message: res.data["message"]);
      }
    } catch (e) {
      log.e(e);
    }
    setBusy(false);
  }

// Future<OrderInfo?> getOrderInfo(CartItem item) async {
//   try {
//     ApiResponse res = await repo.saveOrder({
//       "product": item.product!.id,
//       "quantity": item.quantity,
//     });
//     if (res.statusCode == 200) {
//       return OrderInfo.fromJson(
//           Map<String, dynamic>.from(res.data["orderInfo"]));
//     } else {
//       return null;
//     }
//   } catch (e) {
//     log.e(e);
//     return null;
//   }
// }
}
