import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:io';

import '../app/app.locator.dart';
import '../core/data/repositories/repository.dart';
import '../core/network/api_response.dart';
import '../state.dart';

class MoneyUtils extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue
      ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String newText = newValue.text.replaceAll(',', '');

    if (int.tryParse(newText) != null) {
      newText = NumberFormat("#,##0", "en_US").format(int.parse(newText));
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String formatAmount(int amount) {
    final formatter = NumberFormat("#,##0", "en_US");

    return "₦${formatter.format(amount)}";
  }

  String getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }

  int getAmountAsInt(TextEditingController amount) {
    String text = amount.text.replaceAll(',', ''); // Remove commas
    return int.tryParse(text) ?? 0; // Convert to int, return 0 if null
  }

  // Future<ApiResponse> chargeCard( String paymentMethod, List<String> orderId, PaystackPlugin plugin, BuildContext context) async {
  //
  //   if(paymentMethod == 'wallet'){
  //     ApiResponse res = await locator<Repository>().payForOrder({
  //       "orderId": orderId,
  //       "payment_method": 1,
  //       "reference": getReference(),
  //       "id": profile.value.id
  //     });
  //
  //     if (res.statusCode == 200) {
  //       print('wallet payment was successfully');
  //       return res;
  //     }else{
  //       locator<SnackbarService>()
  //           .showSnackbar(message: res.data["message"]);
  //       return res;
  //     }
  //   }
  //   else if(paymentMethod == 'paystack'){
  //     var charge = Charge()
  //       ..amount = (getSubTotal(cart.value) + getDeliveryFee(cart.value)) *
  //           100 // money in kobo hence the need to multiply the value by 100
  //       ..reference = getReference()
  //       ..email = profile.value.email;
  //     CheckoutResponse response = await plugin.checkout(
  //       context,
  //       method: CheckoutMethod.card,
  //       charge: charge,
  //     );
  //
  //     if (response.status == true) {
  //       ApiResponse res = await locator<Repository>().payForOrder({
  //         "orderId": orderId,
  //         "payment_method": 2,
  //         "reference": charge.reference,
  //         "id": profile.value.id
  //       });
  //
  //       if (res.statusCode == 200) {
  //         print('paystack payment was suceessful');
  //        return res;
  //
  //       } else {
  //         locator<SnackbarService>()
  //             .showSnackbar(message: res.data["message"]);
  //         return res;
  //       }
  //     }
  //   }
  //
  //   return ApiResponse(false, 'Payment method not supported', null, 500);
  //
  // }

  Future<ApiResponse> chargeCardUtil(String paymentMethod, List<String> orderIds, PaystackPlugin plugin, BuildContext context, int amount) async {
    // Prepare common payload
    var payload = {
      "orderId": orderIds,
      "payment_method": getPaymentMethodCode(paymentMethod),
      "reference": getReference(),
      "id": profile.value.id,
    };

    // Handle wallet payment
    if (paymentMethod == 'wallet') {
      var res = await locator<Repository>().payForOrder(payload);
      if (res.statusCode != 200) {
        locator<SnackbarService>().showSnackbar(message: res.data["message"]);
      }
      return res;
    }

    // Handle Paystack payment
    if (paymentMethod == 'paystack') {
      var charge = Charge()
        ..amount = amount * 100  // Convert to kobo
        ..reference = getReference()
        ..email = profile.value.email;

      CheckoutResponse checkoutResponse = await plugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
      );

      if (checkoutResponse.status == true) {
        var response = await locator<Repository>().payForOrder({
          ...payload, // Spread the existing payload
          "reference": charge.reference, // Override the reference with the one from Charge
        });

        if (response.statusCode != 200) {
          locator<SnackbarService>().showSnackbar(message: response.data["message"]);
        }
        return response;
      } else {
        // Create a fake response to wrap the error message
        var errorResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: checkoutResponse.message,
          statusCode: 500,
        );
        return ApiResponse(errorResponse);
      }
    }

    if(paymentMethod == 'binance') {
      var res = await locator<Repository>().payForOrder(payload);
      if (res.statusCode != 200) {
        locator<SnackbarService>().showSnackbar(message: res.data["message"]);
      }
      return res;
    }


    var defaultResponse = Response(
      requestOptions: RequestOptions(path: ''),
      data: "Payment method not supported",
      statusCode: 500,
    );
    return ApiResponse(defaultResponse);
  }


  // String payStackPublicKey = 'pk_test_aae035e8425d5319b6500ef86c0472474a38a5fd';
  String payStackPublicKey = 'pk_live_540bdf095640f7765b0a822f08161087b68df565';
  int getPaymentMethodCode(String paymentMethod) {
    switch (paymentMethod) {
      case 'wallet':
        return 1;
      case 'paystack':
        return 2;
      case 'binance':
        return 3;
      default:
        return 0;
    }
  }
}
