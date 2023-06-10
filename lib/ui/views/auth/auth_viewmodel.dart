import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AuthViewModel extends BaseViewModel {
  final log = getLogger("AuthViewModel");
  final repo = locator<Repository>();
  final snackBar = locator<SnackbarService>();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final cPassword = TextEditingController();

  bool terms = false;

  void toggleTerms() {
    terms = !terms;
    rebuildUi();
  }

  void register(TabController controller) async {
    if (!terms) {
      snackBar.showSnackbar(message: "Accept terms to continue");
      return;
    }
    setBusy(true);

    try {
      ApiResponse res = await repo.register({
        "firstname": firstname.text,
        "lastname": lastname.text,
        "email": email.text,
        "phone": phone.text,
        "country": "Nigeria",
        "password": password.text
      });
      if (res.statusCode == 200) {
        firstname.text = "";
        lastname.text = "";
        email.text = "";
        phone.text = "";
        password.text = "";
        cPassword.text = "";
        terms = false;
        rebuildUi();
        snackBar.showSnackbar(message: res.data["message"]);
        controller.animateTo(0);
      } else {
        if (res.data["message"].runtimeType
            .toString()
            .toLowerCase()
            .contains("list")) {
          snackBar.showSnackbar(message: res.data["message"].join('\n'));
        } else {
          snackBar.showSnackbar(message: res.data["message"]);
        }
      }
    } catch (e) {
      log.e(e);
    }

    setBusy(false);
  }
}
