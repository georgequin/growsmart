import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/models/profile.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:afriprize/core/data/models/profile.dart' as pro;
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/data/models/transaction.dart';
import '../../../state.dart';
import '../../components/empty_state.dart';

class Wallet extends StatefulWidget {
  // final pro.Wallet wallet;

  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  late pro.Wallet wallet = pro.Wallet(balance: 0);
  bool loading = false;
  bool loadingProfile = true;
  List<Transaction> transactions = [];

  @override
  void initState() {
    getProfile();
    getHistory();
    super.initState();
  }

  // void getProfile() async {
  //   try {
  //     ApiResponse res = await locator<Repository>().getProfile();
  //     if (res.statusCode == 200) {
  //       profile.value =
  //           Profile.fromJson(Map<String, dynamic>.from(res.data["user"]));
  //       setState(() {
  //         wallet = profile.value.wallet!;
  //         transactions = (res.data['user']['transaction'] as List)
  //             .map((e) => Transaction.fromJson(Map<String, dynamic>.from(e)))
  //             .toList();
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  void getHistory() async {
    setState(() {
      loading = true;
    });

    try {
      ApiResponse res = await locator<Repository>().getTransactions();
      if (res.statusCode == 200) {
        setState(() {
          //print('this is for the amount${res.data['data']['items'].amount}');
          //print('without amount${res.data['data']['items']}');
          transactions = (res.data['data']['items']
                  as List) // Accessing items array
              .map((e) => Transaction.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        });
      }
    } catch (e) {
      throw Exception("Error Api call");
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> getProfile() async {
    ApiResponse res = await locator<Repository>().getProfile();
    setState(() {
      loadingProfile = false;
      if (res.statusCode == 200) {
        Map<String, dynamic> userData =
            res.data["user"] as Map<String, dynamic>;
        profile.value = Profile.fromJson(userData);
        if (profile.value.wallet != null) {
          wallet = profile.value.wallet!;
        } else {
          wallet = pro.Wallet(balance: 0);
        }
      } else {
        wallet = pro.Wallet(balance: 0);
        locator<SnackbarService>().showSnackbar(message: res.data["message"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My wallet",
          //style: TextStyle(fontFamily: "Panchang" ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getProfile();
        },
        child: ListView(
          children: [
            Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        child: Stack(
                          alignment: Alignment
                              .center, // Centers all children in the stack
                          children: [
                            // Background Image
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 390,
                                child: const Image(
                                  image: AssetImage('assets/images/Frame.png'),
                                  fit: BoxFit
                                      .cover, // Ensures the image covers the container
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Wallet Balance',
                                    style: TextStyle(
                                      color: kcWhiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    '\$${profile.value.accountPointsLocal ?? 0}',
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize:
                                          34, // Size for the dollar amount
                                      fontWeight: FontWeight.w900,
                                      color: kcPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Align(
            //         alignment: Alignment.bottomRight,
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           children: [
            //             Expanded(
            //               child: SubmitButton(
            //                 isLoading: false,
            //                 svgFileName: 'plus.svg',
            //                 iconIsPrefix: true,
            //                 label: "Buy Afriprize Card",
            //                 family: "Panchang",
            //                 textSize: 13,
            //                 submit: () {
            //                   currentModuleNotifier.value = AppModules.raffle;
            //                   locator<NavigationService>().clearStackAndShow(Routes.homeView);
            //                 },
            //                 color: Colors.transparent,
            //                 iconColor: Colors.black,
            //                 textColor: Colors.black,
            //                 boldText: true,
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Credit Card Container
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kcSecondaryColor, // Border color
                          width: 1.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(
                            8.0), // Optional rounded corners
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/send-2.svg', // Replace with your SVG file path
                            color:
                                kcSecondaryColor, // Set the color for the icon
                            height: 17,
                            width: 17,
                          ), // Icon for Credit Card
                          const SizedBox(
                              width: 8.0), // Space between icon and text
                          const Text(
                            'Transfer Credits',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kcLightGrey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    horizontalSpaceTiny,
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kcSecondaryColor, // Border color
                          width: 1.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(
                            8.0), // Optional rounded corners
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/shop-remove.svg', // Replace with your SVG file path
                            color:
                                kcSecondaryColor, // Set the color for the icon
                            height: 17,
                            width: 17,
                          ), // Icon for Debit Card
                          const SizedBox(
                              width: 8.0), // Space between icon and text
                          const Text(
                            'Shop with Points',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kcLightGrey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Transactions",
                    style: TextStyle(
                        fontSize: 18,
                        color: kcBlackColor,
                        fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    "See all",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            loading
                ? Padding(
                    padding: const EdgeInsets.all(26.0),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : transactions.isEmpty
                    ? const EmptyState(
                        animation: "no_transactions.json",
                        label: "No Transaction Yet",
                      )
                    : SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            transactions.sort(
                                (b, a) => b.createdAt!.compareTo(a.createdAt!));
                            Transaction transaction =
                                transactions.reversed.toList()[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){},
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kcWhiteColor, // Replace with your color
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                    child: ListTile(
                                      minLeadingWidth:
                                          10, // Reduced to align with the design
                                      leading: Container(
                                        margin: const EdgeInsets.only(
                                            right: 8), // Adjust spacing if needed
                                        child: transaction == 1
                                            ? SvgPicture.asset(
                                                'assets/icons/shop_out.svg',
                                                height: 28, // Icon size
                                              )
                                            : transaction == 2
                                                ? SvgPicture.asset(
                                                    'assets/icons/card_in.svg',
                                                    height: 28, // Icon size
                                                  )
                                                : transaction == 4
                                                    ? SvgPicture.asset(
                                                        'assets/icons/ticket_out.svg',
                                                        height: 28, // Icon size
                                                      )
                                                    : Container(
                                                        width:
                                                            30, // Width and height of the circle
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          color: kcWhiteColor,
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            color: kcSecondaryColor,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: SvgPicture.asset(
                                                            'assets/images/shop-remove.svg',
                                                            color: kcSecondaryColor,
                                                            width: 14,
                                                            height: 14,
                                                          ),
                                                        ),
                                                      ),
                                      ),
                                      title: Text(
                                        transaction == 1
                                            ? 'Shop Purchase'
                                            : transaction == 2
                                                ? 'Afriprize Card Top-Up'
                                                : transaction == 4
                                                    ? 'Ticket Purchase'
                                                    : 'Purchase',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .black, // Changed color to black to match the design
                                        ),
                                      ),
                                      subtitle: Text(
                                        DateFormat('EEEE, d MMM hh:mm a').format(
                                          DateTime.parse(transaction.createdAt!),
                                        ), // Changed format to match design
                                        style: const TextStyle(
                                          color: Colors
                                              .grey, // Adjusted color to grey to match design
                                          fontSize: 14,
                                        ),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            transaction == 1
                                                ? '-\$${transaction.amount}'
                                                : transaction == 2
                                                    ? '+\$${transaction.amount}'
                                                    : transaction == 4
                                                        ? '-\$${transaction.amount}'
                                                        : 'Purchase',
                                            style: TextStyle(
                                              color: transaction == 1
                                                  ? Colors.red
                                                  : transaction == 2
                                                      ? Colors.green
                                                      : transaction == 4
                                                          ? Colors.red
                                                          : kcPrimaryColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ),
                                  ),
                            );

                          },
                          itemCount: transactions.length,
                        ),
                      )
          ],
        ),
      ),
    );
  }
}
