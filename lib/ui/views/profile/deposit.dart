import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/components/text_field_widget.dart';
import 'package:afriprize/ui/views/profile/payment_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Deposit extends StatefulWidget {
  const Deposit({Key? key}) : super(key: key);

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  final amount = TextEditingController();
  bool isLoading = false;

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
            TextFieldWidget(hint: "Amount", controller: amount),
            verticalSpaceMedium,
            SubmitButton(
              isLoading: isLoading,
              label: "Continue",
              submit: () async {
                setState(() {
                  isLoading = true;
                });

                try {
                  ApiResponse res = await locator<Repository>().initTransaction(
                    {
                      "amount": double.parse(amount.text),
                    },
                  );
                  if (res.statusCode == 200) {
                    String url =
                        res.data["paystack"]["data"]["authorization_url"];
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return PaymentView(url: url);
                    }));
                  } else {
                    locator<SnackbarService>()
                        .showSnackbar(message: res.data['message']);
                  }
                } catch (e) {
                  print(e);
                }
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
}
