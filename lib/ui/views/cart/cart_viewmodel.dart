import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/models/raffle_cart_item.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/core/utils/local_store_dir.dart';
import 'package:afriprize/core/utils/local_stotage.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/views/cart/raffle_reciept.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/app.dialogs.dart';
import '../../../app/app.router.dart';
import '../../../core/data/models/order_info.dart';
import '../../../utils/binance_pay.dart';
import '../../../utils/money_util.dart';
import 'checkout.dart';
import 'custom_reciept.dart';


/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///



class CartViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final snackBar = locator<SnackbarService>();
  final log = getLogger("CartViewModel");
  List<CartItem> itemsToDelete = [];
  List<RaffleCartItem> itemsToDeleteRaffle = [];
  int shopSubTotal = 0;
  int raffleSubTotal = 0;
  int deliveryFee = 0;
  final refferalCode = TextEditingController();

  ValueNotifier<PaymentMethod> selectedPaymentMethod = ValueNotifier(PaymentMethod.binancePay);
  ValueNotifier<bool> isPaymentProcessing = ValueNotifier(false);


  PaymentMethod get selectedMethod => selectedPaymentMethod.value;

  final bool _isDisposed = false;

  @override
  void dispose() {
    selectedPaymentMethod.dispose();
    super.dispose();
  }


  void selectMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
    notifyListeners(); // Notify overall ViewModel listeners
  }

  void addRemoveDelete(CartItem item) {
    itemsToDelete.contains(item)
        ? itemsToDelete.remove(item)
        : itemsToDelete.add(item);
    rebuildUi();
  }

  void addRemoveDeleteRaffle(RaffleCartItem item) {
    itemsToDeleteRaffle.contains(item)
        ? itemsToDeleteRaffle.remove(item)
        : itemsToDeleteRaffle.add(item);
    rebuildUi();
  }

  void clearCart() async{
    for (var element in itemsToDelete) {
      shopCart.value.remove(element);
    }
    itemsToDelete.clear();
    shopCart.notifyListeners();
    //update local cart
    List<Map<String, dynamic>> storedList =
    shopCart.value.map((e) => e.toJson()).toList();
    await locator<LocalStorage>().save(LocalStorageDir.cart, storedList);
    rebuildUi();
    getShopSubTotal();
  }

  // void clearRaffleCart() async{
  //   for (var element in itemsToDeleteRaffle) {
  //     raffleCart.value.remove(element);
  //   }
  //   itemsToDelete.clear();
  //   raffleCart.notifyListeners();
  //   List<Map<String, dynamic>> storedList =
  //   raffleCart.value.map((e) => e.toJson()).toList();
  //   await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);
  //   rebuildUi();
  //   getRaffleSubTotal();
  // }

  void clearRaffleCart() async {
    setBusy(true);
    try {
      // Loop through items to delete
      for (var element in itemsToDeleteRaffle) {
        // Remove from the online cart
        ApiResponse res = await repo.deleteFromCart(element.raffle!.id!);
        if (res.statusCode == 200) {
          // Remove from the local cart if successful
          raffleCart.value.remove(element);
        } else {
          snackBar.showSnackbar(message: "Failed to delete item from cart: ${res.data['message']}");
        }
      }

      // Clear local list of items to delete
      itemsToDeleteRaffle.clear();

      // Update local cart storage
      raffleCart.notifyListeners();
      List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
      await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);

      rebuildUi();
      getRaffleSubTotal();
    } catch (e) {
      log.e(e);
      snackBar.showSnackbar(message: "An error occurred while clearing the cart: $e");
    } finally {
      setBusy(false);
    }
  }

  void getShopSubTotal() {
    int total = 0;
    for (var element in shopCart.value) {
      final product = element.product;
      if (product != null && product.productPrice != null && element.quantity != null) {
        total += product.productPrice! * element.quantity!;
      }
    }

    shopSubTotal = total;
    rebuildUi();
  }

  void getRaffleSubTotal() {
    int total = 0;
    for (var element in raffleCart.value) {
      final raffle = element.raffle;
      total += (raffle?.ticketPrice ?? 0) * element.quantity!;
    }

    raffleSubTotal = total;
    rebuildUi();
  }

  void getDeliveryTotal() {
    int total = 0;

    for (var element in shopCart.value) {
      total = total + (element.product?.shippingFee ?? 0);
    }

    deliveryFee = total;
    rebuildUi();
  }

  void checkout() async {
    if (shopCart.value.isEmpty) {
      return null;
    }


    setBusy(true);
    try {
      ApiResponse res = await repo.saveOrder({
        "items": shopCart.value
            .map((e) => {"id": e.product!.id, "quantity": e.quantity})
            .toList(),
           "type": 1
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

  void checkoutRaffle(BuildContext context) async {
    if (raffleCart.value.isEmpty) {
      return null;
    }
    isPaymentProcessing.value = true;
    setBusy(true);
    try {
      ApiResponse res = await repo.saveOrder({
        "payment_method": selectedMethod.name
        // "referral_code": refferalCode.text
      });
      if (res.statusCode == 201) {
        String paymentLink = res.data['data']['payment_link'];

        final Uri toLaunch = Uri.parse(paymentLink);

        if (!await launchUrl(toLaunch, mode: LaunchMode.inAppBrowserView)) {
          snackBar.showSnackbar(message: "Could not launch payment link");
          throw Exception('Could not launch $paymentLink');
        }
        // processPayment(list, selectedMethod, context, AppModules.raffle);

      } else {
        snackBar.showSnackbar(message: res.data["message"]);
        isPaymentProcessing.value = false;
      }
    } catch (e) {
      log.e(e);
    }
  }

  processPayment(List<OrderInfo> list, PaymentMethod paymentMethod, BuildContext context, AppModules module) async {
    // Calculate the amount
    int amount = raffleSubTotal;
    // Retrieve order IDs
    List<String> orderIds = list.map((e) => e.id.toString()).toList();

    try{
      ApiResponse res = await MoneyUtils().chargeCardUtil(paymentMethod, orderIds, context, amount);

      if (res.statusCode == 200) {
        if (paymentMethod == PaymentMethod.binancePay) {
          Map<String, dynamic> binanceData = res.data['binance']['data'];
          await Future.delayed(const Duration(seconds: 1));
          showBinancePayModal(context,binanceData, orderIds, module);
        }
        else {
          Navigator.pop(context);
          showReceipt(module, context);
        }
      } else {
        Navigator.pop(context);
        locator<SnackbarService>().showSnackbar(message: res.data["message"]);
        locator<NavigationService>().replaceWithHomeView();
      }
    }catch(e){
      log.e(e);
    }finally{
     
      isPaymentProcessing.value = false;
      setBusy(false);
    }


  }

  void showBinancePayModal(
      BuildContext context,
      Map binanceData,
      List<String> orderIds,
      AppModules module,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return BinancePayModal(binanceData: binanceData, orderIds: orderIds, module: module);
      },
    );
  }

  void showReceipt(AppModules module, BuildContext context) {

    if(module == AppModules.raffle){
      List<RaffleCartItem> receiptCart = List<RaffleCartItem>.from(raffleCart.value);
      raffleCart.value.clear();
      raffleCart.notifyListeners();
      List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
      locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);


      showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return RaffleReceiptPage(cart:receiptCart);
        },
      );
    }else{
      List<CartItem> receiptCart = List<CartItem>.from(shopCart.value);

      shopCart.value.clear();
      shopCart.notifyListeners();
      List<Map<String, dynamic>> storedList = shopCart.value.map((e) => e.toJson()).toList();
      locator<LocalStorage>().save(LocalStorageDir.cart, storedList);


      showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return ReceiptPage(cart:receiptCart);
        },
      );
    }



  }

  Future<void> fetchOnlineCart() async {
    setBusy(true);
    try {
      ApiResponse res = await repo.cartList();
      if (res.statusCode == 200) {
        // Access the 'items' from the response 'data'
        List<dynamic> items = res.data["data"]["items"];

        print('online cart is:  $items');

        // Map the items list to List<RaffleCartItem>
        List<RaffleCartItem> onlineItems = items
            .map((item) => RaffleCartItem.fromJson(Map<String, dynamic>.from(item)))
            .toList();

        // Sync online items with the local cart
        raffleCart.value = onlineItems;

        // Update local storage
        List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
        await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);
      } else {
        snackBar.showSnackbar(message: res.data["message"]);
      }
    } catch (e) {
      log.e(e);
      snackBar.showSnackbar(message: "Failed to load cart from server: $e");
    } finally {
      setBusy(false);
    }
  }


}
