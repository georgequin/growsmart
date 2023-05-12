import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:flutter/material.dart';

import '../../common/ui_helpers.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Checkout",
          style: TextStyle(
            color: kcBlackColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Card(
            child: ExpansionTile(
              title: Text(
                "Order review",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("2 items in cart"),
            ),
          ),
          verticalSpaceMedium,
          const Card(
            child: ExpansionTile(
              title: Text(
                "Billing summary",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          verticalSpaceMedium,
          const Card(
            child: ExpansionTile(
              title: Text(
                "Shipping details",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          verticalSpaceMedium,
          const Card(
            child: ExpansionTile(
              title: Text(
                "Payment method",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          verticalSpaceMassive,
          SubmitButton(
            isLoading: false,
            label: "Pay \$70",
            submit: () {},
            color: kcPrimaryColor,
            boldText: true,
          )
        ],
      ),
    );
  }
}
