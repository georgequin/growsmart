import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/models/bank.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class WithdrawViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final snackBar = locator<SnackbarService>();
  final log = getLogger("WithdrawViewModel");
  final amount = TextEditingController();
  final accountName = TextEditingController();
  final accountNumber = TextEditingController();
  List<Bank> banks = [];
  String? selectedBank;

  void changeBank(v) {
    selectedBank = v;
    rebuildUi();
  }

  void withdraw() async {
    setBusy(true);
    Bank bank =
        banks.where((element) => element.name == selectedBank).toList().first;
    try {
      ApiResponse res = await repo.withdraw({
        "account_name": "OBIOHA MCDAVID CHIBUEZE",
        "account_number": "4081122674",
        "bank_code": "050",
        "amount": 5000,
        "reason": "flexing"
      });
      if (res.statusCode == 200) {
      } else {
        snackBar.showSnackbar(message: res.data["message"]);
      }
    } catch (e) {
      log.e(e);
    }
    setBusy(false);
  }

  void getBanks() async {
    setBusyForObject(banks, true);
    try {
      ApiResponse res = await repo.getBanks();
      if (res.statusCode == 200) {
        banks = (res.data["banks"]["data"] as List)
            .map((e) => Bank.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    }
    setBusyForObject(banks, false);
  }
}
