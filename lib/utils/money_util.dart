import 'package:afriprize/core/utils/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:io';

import '../app/app.locator.dart';
import '../core/data/repositories/repository.dart';
import '../core/network/api_response.dart';
import '../state.dart';
import 'flutterwave-service.dart';

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

    return "\$${formatter.format(amount)}";
  }

  int getRate(int amount) {
    final formatter = NumberFormat("#,##0", "en_US");

    amount =  1450 * amount;
    return amount;
  }

  String formatAmountToDollars(int amount) {
    final formatter = NumberFormat("#,##0", "en_US");

    return "\$${formatter.format(amount)}";
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

  Future<ApiResponse> chargeCardUtil(PaymentMethod paymentMethod, List<String> orderIds, BuildContext context, int amount) async {

    String convertAmount = '';
    //convert amount
    var res = await locator<Repository>().convertToNaira(amount.toString());
    if (res.statusCode == 200) {
      convertAmount = (res.data['rate']['source']['amount']).toString();
    }

    // Prepare common payload
    var payload = {
      "orderId": orderIds,
      "payment_method": getPaymentMethodCode(paymentMethod),
      "reference": getReference(),
      "id": profile.value.id,
    };

    // Handle wallet payment
    if (paymentMethod == PaymentMethod.wallet) {
      var res = await locator<Repository>().payForOrder(payload);
      if (res.statusCode != 200) {
        locator<SnackbarService>().showSnackbar(message: res.data["message"]);
      }
      return res;
    }

    // Handle Paystack payment
    // if (paymentMethod == PaymentMethod.payStack) {
    //   var charge = Charge()
    //     ..amount = amount * 100  // Convert to kobo
    //     ..reference = getReference()
    //     ..email = profile.value.email;
    //
    //   CheckoutResponse checkoutResponse = await plugin.checkout(
    //     context,
    //     method: CheckoutMethod.card,
    //     charge: charge,
    //   );
    //
    //   if (checkoutResponse.status == true) {
    //     var response = await locator<Repository>().payForOrder({
    //       ...payload, // Spread the existing payload
    //       "reference": charge.reference, // Override the reference with the one from Charge
    //     });
    //
    //     if (response.statusCode != 200) {
    //       locator<SnackbarService>().showSnackbar(message: response.data["message"]);
    //     }
    //     return response;
    //   } else {
    //     // Create a fake response to wrap the error message
    //     var errorResponse = Response(
    //       requestOptions: RequestOptions(path: ''),
    //       data: checkoutResponse.message,
    //       statusCode: 500,
    //     );
    //     return ApiResponse(errorResponse);
    //   }
    // }

    // Handle flutterwave payment
    if (paymentMethod == PaymentMethod.flutterWave) {
      // Assuming amount, currency, and customer email are passed as parameters
      final FlutterwavePaymentService paymentService = FlutterwavePaymentService();
      ChargeResponse response = await paymentService.makePayment(
        context: context,
        amount: convertAmount,
        isTestMode: AppConfig.isTestMode,
      );

      if (response.success == true || response.status == 'completed') {
        print('flutterwave response was success');
        ApiResponse res = await locator<Repository>().payForOrder({
                  "orderId": orderIds,
                  "payment_method": 4,
                  "reference": response.transactionId,
                  "id": profile.value.id
                });
        if (res.statusCode == 200) {
                  print('flutterwave payment was suceessful');
                 return res;

                } else {
          print('backend call response failed');
                  locator<SnackbarService>()
                      .showSnackbar(message: res.data["message"] ?? 'system error');
                  return res;
                }
      }else{
        print('flutterwave payment was different ${response.success}');
        locator<SnackbarService>().showSnackbar(message: response.status ?? 'flutterwave payment failed');
      }
    }

    if(paymentMethod == PaymentMethod.binancePay) {
      var res = await locator<Repository>().payForOrder(payload);
      if (res.statusCode != 200) {
        locator<SnackbarService>().showSnackbar(message: res.data["message"] ?? 'system error');
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


  int getPaymentMethodCode(PaymentMethod paymentMethod) {
    switch (paymentMethod) {
      case PaymentMethod.wallet:
        return 1;
      case PaymentMethod.payStack:
        return 2;
      case PaymentMethod.binancePay:
        return 3;
      case PaymentMethod.flutterWave:
        return 4;
      default:
        return 0;
    }
  }

}
