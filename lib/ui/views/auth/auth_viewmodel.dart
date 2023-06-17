import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/core/utils/local_store_dir.dart';
import 'package:afriprize/core/utils/local_stotage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
  bool obscure = true;
  bool terms = false;
  bool remember = false;

  void toggleRemember() {
    remember = !remember;
    rebuildUi();
  }

  void toggleObscure() {
    obscure = !obscure;
    rebuildUi();
  }

  void toggleTerms() {
    terms = !terms;
    rebuildUi();
  }

  void login() async {
    setBusy(true);

    try {
      ApiResponse res = await repo.login({
        "email": email.text,
        "password": password.text,
      });
      if (res.statusCode == 200) {
        Map<String, dynamic> userDecoded = JwtDecoder.decode(res.data["token"]);
        print(userDecoded);
        // loggedInUser.value =
        //     User.fromJson(Map<String, dynamic>.from(res.data["data"]));
        locator<LocalStorage>()
            .save(LocalStorageDir.authToken, res.data["token"]);
        locator<LocalStorage>().save(LocalStorageDir.remember, terms);
        if (terms) {
          locator<LocalStorage>().save(LocalStorageDir.lastEmail, email.text);
        } else {
          locator<LocalStorage>().delete(LocalStorageDir.lastEmail);
        }
        locator<NavigationService>().clearStackAndShow(Routes.homeView);
      } else {
        snackBar.showSnackbar(message: res.data["message"]);
      }
    } catch (e) {
      log.i(e);
    }

    setBusy(false);
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
        snackBar.showSnackbar(message: res.data["message"]);
        controller.animateTo(0);
        locator<NavigationService>().replaceWithOtpView(email: email.text);
        firstname.text = "";
        lastname.text = "";
        email.text = "";
        phone.text = "";
        password.text = "";
        terms = false;
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
