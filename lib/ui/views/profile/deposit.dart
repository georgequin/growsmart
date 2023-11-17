import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/components/text_field_widget.dart';
import 'package:afriprize/ui/views/profile/payment_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/data/models/profile.dart';
import '../../../state.dart';
import '../../../utils/moneyUtil.dart';
import '../../components/payment_success_page.dart';
import '../cart/custom_reciept.dart';

class Deposit extends StatefulWidget {
  const Deposit({Key? key}) : super(key: key);

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  final amount = TextEditingController();
  bool isLoading = false;
  final plugin = PaystackPlugin();

  @override
  void initState() {
    plugin.initialize(publicKey: MoneyUtils().payStackPublicKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deposit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter the amount you wish to deposit",
              style: TextStyle(),
            ),
            verticalSpaceLarge,
            // TextFieldWidget(hint: "Amount", controller: amount),
          TextField(
            controller: amount,
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              MoneyUtils(),
            ],
            decoration: InputDecoration(
              hintText: "Amount",
            ),
          ),
            verticalSpaceMedium,
            SubmitButton(
              isLoading: isLoading,
              label: "Continue",
              submit: () async {
                setState(() {
                  isLoading = true;
                });

                chargeCard();
                setState(() {
                  isLoading = false;
                });
              },
              color: kcPrimaryColor,
            )
          ],
        ),
      ),
    );
  }





  chargeCard() async {
    var charge = Charge()
      ..amount = MoneyUtils().getAmountAsInt(amount) *
          100 //the money should be in kobo hence the need to multiply the value by 100
      ..reference = MoneyUtils().getReference()
      ..email = profile.value.email;
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    if (response.status == true) {
      print('paystack payment successful');
    ApiResponse res = await locator<Repository>().initTransaction(
    {
    "amount": MoneyUtils().getAmountAsInt(amount),
    "reference": charge.reference
    });

      if (res.statusCode == 200) {

         showSuccess();
      } else {
        locator<SnackbarService>()
            .showSnackbar(message: res.data["message"]);
      }
    }
  }

  showSuccess(){

    Navigator.pop(context);

    return Navigator.push(context, MaterialPageRoute(
      builder: (context) => PaymentSuccessPage(
        title: "Wallet Funded Sucessfully!",
                animation: 'payment_success.json',
                callback: () {
                  Navigator.popAndPushNamed(context, Routes.wallet);
                  // locator<NavigationService>()
                  //     .navigateToWallet(
                  //     wallet: profile.value.wallet ?? Wallet());
        }
      ),
    ),);
    // return showModalBottomSheet(
    //   isScrollControlled: true,
    //   context: context,
    //   builder: (BuildContext context) {
    //     return PaymentSuccessPage(
    //         title: "Wallet Funded Sucessfully!",
    //         animation: 'payment_success.json',
    //         callback: () {
    //           locator<NavigationService>()
    //               .navigateToWallet(
    //               wallet: profile.value.wallet ?? Wallet());
    //         });
    //     // ReceiptWidget(info: info,);
    //   },
    // );
  }

  // void showReceipt() {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return ReceiptWidget(
  //
  //       );
  //     },
  //   );
  // }
}
