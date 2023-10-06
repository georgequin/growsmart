import 'dart:convert';

import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/core/utils/local_store_dir.dart';
import 'package:afriprize/core/utils/local_stotage.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/views/auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/data/models/profile.dart';

enum RegistrationResult { success, failure }
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

  init() async {
    bool rem = await locator<LocalStorage>().fetch(LocalStorageDir.remember);
    String? lastEmail =
        await locator<LocalStorage>().fetch(LocalStorageDir.lastEmail);

    remember = rem;

    if (lastEmail != null) {
      email.text = lastEmail;
    }
    rebuildUi();
  }

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
        userLoggedIn.value = true;
        profile.value =
            Profile.fromJson(Map<String, dynamic>.from(res.data["user"]));
        locator<LocalStorage>()
            .save(LocalStorageDir.authToken, res.data["token"]);
        locator<LocalStorage>()
            .save(LocalStorageDir.authUser, jsonEncode(res.data["user"]));
        locator<LocalStorage>().save(LocalStorageDir.remember, remember);
        if (remember) {
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



  Future<RegistrationResult> register() async {
    if (!terms) {
      snackBar.showSnackbar(message: "Accept terms to continue");
      return RegistrationResult.failure;
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

        locator<NavigationService>().replaceWithOtpView(email: email.text);
        firstname.text = "";
        lastname.text = "";
        email.text = "";
        phone.text = "";
        password.text = "";
        terms = false;
        return RegistrationResult.success;
      } else {
        if (res.data["message"].runtimeType
            .toString()
            .toLowerCase()
            .contains("list")) {
          snackBar.showSnackbar(message: res.data["message"].join('\n'));
          return RegistrationResult.success;
        } else {
          snackBar.showSnackbar(message: res.data["message"]);
          return RegistrationResult.success;
        }
      }
    } catch (e) {
      log.e(e);
      return RegistrationResult.failure;
    }

    setBusy(false);
  }
}
