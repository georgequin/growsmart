import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/models/profile.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/ui/common/app_colors.dart';
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
          transactions = (res.data['userTransactions'] as List)
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
        Map<String, dynamic> userData = res.data["user"] as Map<String, dynamic>;
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
          "Wallet",
          style: TextStyle(fontFamily: "Panchang" ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            getProfile();
          },
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Container(
                        margin: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 0.0),
                        child: const Image(image: AssetImage('assets/images/wallet_home.png'), height: 210),
                        // SvgPicture.asset(
                        //   'assets/images/wallet_home.png',
                        //   height: 210,
                        // ),
                      ),

                    ],
                  ),
                  Positioned(
                      bottom: 15, // Adjust the positioning as you see fit
                      left: 33, // Adjust the positioning as you see fit
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Afriprize Card Balance',
                            style: TextStyle(
                                color: kcPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11
                            ),
                          ),
                          Text(
                            '\$${wallet.balance ?? 0}',
                            style: const TextStyle(
                              fontSize: 34, // Size for the dollar amount
                              fontWeight: FontWeight.w900,
                              color: kcPrimaryColor,
                            ),
                          ),
                        ],
                      )
                    ),
                ],
              ),
              Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: SubmitButton(
                              isLoading: false,
                              svgFileName: 'plus.svg',
                              iconIsPrefix: true,
                              label: "Buy Afriprize Card",
                              family: "Panchang",
                              textSize: 13,
                              submit: () {
                                currentModuleNotifier.value = AppModules.raffle;
                                locator<NavigationService>().clearStackAndShow(Routes.homeView);
                              },
                              color: Colors.transparent,
                              iconColor: Colors.black,
                              textColor: Colors.black,
                              boldText: true,
                            ),
                          )
                        ],
                      ),
                    ),

              const SizedBox(
                height: 20,
              ),
              const Text(
                "Transactions",
                style: TextStyle(fontSize: 15, color: kcBlackColor, fontFamily: "Panchang", fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : transactions.isEmpty
                      ? const EmptyState(
                          animation: "no_transactions.json",
                          label: "No Transaction Yet",
                        )
                      : SizedBox(
                          height: 350,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              transactions.sort((b, a) => b.created!.compareTo(a.created!));
                              Transaction transaction = transactions.reversed.toList()[index];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade300), // Adjusted color to light grey
                                  ),
                                ),
                                child: ListTile(
                                  minLeadingWidth: 10, // Reduced to align with the design
                                  leading: Container(
                                    margin: const EdgeInsets.only(right: 8), // Adjust spacing if needed
                                    child: transaction.type == 1 ?  SvgPicture.asset(
                                      'assets/icons/shop_out.svg',
                                      height: 28, // Icon size
                                    ) : transaction.type == 2 ? SvgPicture.asset(
                                      'assets/icons/card_in.svg',
                                      height: 28, // Icon size
                                    ) : transaction.type == 4 ? SvgPicture.asset(
                                      'assets/icons/ticket_out.svg',
                                      height: 28, // Icon size
                                    ) :
                                    const Icon(
                                       Icons.monetization_on, // Adjusted to + for credit, - for debit
                                      color: kcPrimaryColor,
                                    ),
                                  ),
                                  title: Text(
                                    transaction.type ==  1 ? 'Shop Purchase' : transaction.type == 2 ? 'Afriprize Card Top-Up' : transaction.type == 4 ? 'Ticket Purchase' : 'purchase',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Changed color to black to match the design
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat('EEEE, d MMM hh:mm a').format(DateTime.parse(transaction.created!)), // Changed format to match design
                                    style: const TextStyle(
                                      color: Colors.grey, // Adjusted color to grey to match design
                                      fontSize: 14,
                                    ),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        transaction.type ==  1 ? '-\$${transaction.amount}' : transaction.type == 2 ? '+\$${transaction.amount}' : transaction.type == 4 ? '-\$${transaction.amount}' : 'purchase',
                                        style: TextStyle(
                                          color: transaction.type ==  1 ? Colors.red : transaction.type == 2 ? Colors.green : transaction.type == 4 ? Colors.red : kcPrimaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: transactions.length,
                          ),

              ),
              const SizedBox(
                height: 50,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
