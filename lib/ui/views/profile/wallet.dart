import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/models/profile.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/views/profile/deposit.dart';
import 'package:flutter/material.dart';
import 'package:afriprize/core/data/models/profile.dart' as pro;
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
  late pro.Wallet wallet;
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
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            getProfile();
          },
          child: ListView(
            padding: const EdgeInsets.all(30),
            children: [
              verticalSpaceMedium,
              Container(
                height: 150,
                decoration: BoxDecoration(
                    color: kcSecondaryColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        " Available Balance",
                        style: TextStyle(fontSize: 18, color: kcWhiteColor),
                      ),
                      loadingProfile ? const CircularProgressIndicator()
                          : Text(
                        "N${NumberFormat.simpleCurrency(name: "").format(wallet.balance ?? 0)}",
                        style: const TextStyle(
                          fontSize: 30,
                          color: kcWhiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),


                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Expanded(
                  //   child: SubmitButton(
                  //     isLoading: false,
                  //     label: "Withdraw",
                  //     submit: () {
                  //       locator<NavigationService>()
                  //           .navigateTo(Routes.withdrawView);
                  //     },
                  //     color: kcPrimaryColor,
                  //     boldText: true,
                  //   ),
                  // ),
                  // const SizedBox(width: 30),
                  Expanded(
                    child: SubmitButton(
                      isLoading: false,
                      icon: Icons.add_circle_outline,
                      label: "Add money",
                      submit: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (ctx) {
                          return const Deposit();
                        }));
                      },
                      color: Colors.transparent,
                      iconColor: Colors.black,
                      textColor: Colors.black,
                      boldText: true,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Transaction History",
                style: TextStyle(fontSize: 18, color: kcLightGrey),
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
                                  // leading: Container(
                                  //   margin: EdgeInsets.only(right: 8), // Adjust spacing if needed
                                  //   child:
                                  //   // Icon(
                                  //   //   transaction.type == 2 ? Icons.add : Icons.remove, // Adjusted to + for credit, - for debit
                                  //   //   color: transaction.type == 2 ? Colors.green : Colors.red,
                                  //   // ),
                                  // ),
                                  title: Text(
                                    transaction.type == 2 ? 'Wallet Top Up' : 'Purchase', // Changed from 'Transaction' to match design
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Changed color to black to match the design
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat('EEEE, d MMM').format(DateTime.parse(transaction.created!)), // Changed format to match design
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
                                        transaction.type == 2 ? "+N${transaction.amount}" : "-N${transaction.amount}",
                                        style: TextStyle(
                                          color: transaction.type == 2 ? Colors.green : Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('hh:mm a').format(DateTime.parse(transaction.created!)), // Added to match the time design
                                        style: const TextStyle(
                                          color: Colors.grey, // Adjusted color to grey to match design
                                          fontSize: 14,
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
