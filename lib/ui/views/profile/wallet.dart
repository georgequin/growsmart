import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/views/profile/deposit.dart';
import 'package:flutter/material.dart';
import 'package:afriprize/core/data/models/profile.dart' as profile;

class Wallet extends StatefulWidget {
  final profile.Wallet wallet;

  const Wallet({required this.wallet, Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Wallet",
          style: TextStyle(color: kcBlackColor),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(30),
          children: [
            verticalSpaceMedium,
            Container(
              height: 150,
              decoration: BoxDecoration(
                  color: kcPrimaryColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Balance",
                      style: TextStyle(fontSize: 18, color: kcWhiteColor),
                    ),
                    Text(
                      "N${widget.wallet.balance}",
                      style: const TextStyle(
                        fontSize: 30,
                        color: kcWhiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            // const Text(
            //   "Transaction History",
            //   style: TextStyle(fontSize: 18, color: kcLightGrey),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemBuilder: (context, index) {
            //     return Container(
            //       decoration: const BoxDecoration(
            //           border: Border(bottom: BorderSide(color: kcLightGrey))),
            //       child: const ListTile(
            //         minLeadingWidth: 16,
            //         leading: Icon(
            //           Icons.arrow_downward,
            //           color: Colors.green,
            //         ),
            //         title: Text(
            //           "Transaction (ID: 02576718)",
            //           style: TextStyle(fontSize: 15),
            //         ),
            //         subtitle: Text(
            //           "Thursday 16th March 2023",
            //           style: TextStyle(color: kcWhiteColor, fontSize: 12),
            //         ),
            //         trailing: Text(
            //           "N35,000.00",
            //           style:
            //               TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //         ),
            //       ),
            //     );
            //   },
            //   itemCount: 3,
            // ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SubmitButton(
                    isLoading: false,
                    label: "Withdraw",
                    submit: () {
                      // locator<NavigationService>()
                      //     .navigateTo(Routes.withdrawView);
                    },
                    color: kcPrimaryColor,
                    boldText: true,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: SubmitButton(
                    isLoading: false,
                    label: "Deposit",
                    submit: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return const Deposit();
                      }));
                    },
                    color: kcMediumGrey,
                    boldText: true,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
