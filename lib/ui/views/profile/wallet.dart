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
  final pro.Wallet wallet;

  const Wallet({required this.wallet, Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  late pro.Wallet wallet;
  bool loading = false;
  List<Transaction> transactions = [];

  @override
  void initState() {
    wallet = widget.wallet;
    getHistory();
    super.initState();
  }

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
      print(e);
    }

    setState(() {
      loading = false;
    });
  }

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
        child: RefreshIndicator(
          onRefresh: () async {
            ApiResponse res = await locator<Repository>().getProfile();
            if (res.statusCode == 200) {
              profile.value =
                  Profile.fromJson(Map<String, dynamic>.from(res.data["user"]));
              setState(() {
                wallet = profile.value.wallet!;
              });
            }
          },
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
                        "N${NumberFormat.simpleCurrency(name: "").format(wallet.balance ?? 0)}",
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
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Transaction transaction = transactions[index];
                            return Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: kcLightGrey))),
                              child: ListTile(
                                minLeadingWidth: 16,
                                leading: const Icon(
                                  Icons.arrow_downward,
                                  color: Colors.green,
                                ),
                                title: Text(
                                  "Transaction (ID: ${transaction.id})",
                                  style: const TextStyle(fontSize: 15),
                                ),
                                subtitle: Text(
                                  DateFormat('E d MMM y').format(
                                      DateTime.parse(transaction.created!)),
                                  style: const TextStyle(
                                      color: kcWhiteColor, fontSize: 12),
                                ),
                                trailing: Text(
                                  "N${NumberFormat.simpleCurrency(name: "").format(transaction.amount)}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          },
                          itemCount: transactions.length,
                        ),
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
                        locator<NavigationService>()
                            .navigateTo(Routes.withdrawView);
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
      ),
    );
  }
}
