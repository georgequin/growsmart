import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../core/data/models/profile.dart';
import '../../../core/data/repositories/repository.dart';
import '../../../core/network/api_response.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../../state.dart';


/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///


enum RegistrationResult { success, failure }
class AuthViewModel extends BaseViewModel {
  final log = getLogger("AuthViewModel");
  final repo = locator<Repository>();
  final snackBar = locator<SnackbarService>();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final genderController = TextEditingController();
  String? selectedGender;
  late String phoneValue = "";
  late PhoneNumber phoneNumber;
  late String countryId = "";
  final password = TextEditingController();
  final cPassword = TextEditingController();
  bool obscure = true;
  bool terms = false;
  bool remember = false;

  final initialEmail = TextEditingController();
  final otp = TextEditingController();


  bool isOtpRequested = false;
  bool isLoading = false;


  init() async {

    // bool rem = await locator<LocalStorage>().fetch(LocalStorageDir.remember);
    String? token = await locator<LocalStorage>().fetch(LocalStorageDir.authToken);
    String? lastEmail = await locator<LocalStorage>().fetch(LocalStorageDir.lastEmail);
    // remember = rem;


    // If remember me is true and we have a token, validate it
    if (remember && token != null && JwtDecoder.isExpired(token)) {
      // Here you should make a call to your backend to validate the token
      // bool isValidToken = await validateToken(token);
      // if (isValidToken) {
        userLoggedIn.value = true;
        // Retrieve and set user profile from saved JSON in local storage
        String? userJson =
        await locator<LocalStorage>().fetch(LocalStorageDir.authUser);
        if (userJson != null) {
          profile.value = Profile.fromJson(jsonDecode(userJson));
        }
        locator<NavigationService>().clearStackAndShow(Routes.homeView);
        return;
      // }
    }

    if( token != null && !JwtDecoder.isExpired(token)){
      await locator<LocalStorage>()
          .delete(LocalStorageDir.authToken);
      userLoggedIn.value = false;
    }

    // Set the lastEmail if remember me is true
    if (remember) {
      String? lastEmail =
      await locator<LocalStorage>().fetch(LocalStorageDir.lastEmail);
      if (lastEmail != null) {
        email.text = lastEmail;
      }
    }


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
        locator<LocalStorage>().save(LocalStorageDir.authToken, res.data["token"]);
        locator<LocalStorage>().save(LocalStorageDir.authRefreshToken, res.data["refresh_token"]);
        locator<LocalStorage>().save(LocalStorageDir.authUser, jsonEncode(res.data["user"]));
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


    // if (!terms) {
    //   snackBar.showSnackbar(message: "Accept terms to continue");
    //   return RegistrationResult.failure;
    // }
    setBusy(true);

    try {
      ApiResponse res = await repo.register({
        "firstname": firstname.text,
        "lastname": lastname.text,
        "userId":  profile.value.id,
        "password": password.text,

      });
      if (res.statusCode == 200) {

        print('response is ${res.data}');

        userLoggedIn.value = true;
        profile.value =
            Profile.fromJson(Map<String, dynamic>.from(res.data["User"]));
        locator<LocalStorage>().save(LocalStorageDir.authToken, res.data["token"]);
        locator<LocalStorage>().save(LocalStorageDir.authRefreshToken, res.data["refresh_token"]);
        locator<LocalStorage>().save(LocalStorageDir.authUser, jsonEncode(res.data["User"]));


        snackBar.showSnackbar(message: res.data["message"]);
        locator<NavigationService>().clearStackAndShow(Routes.homeView);
        setBusy(false);
        return RegistrationResult.success;
      } else {
        setBusy(false);

        if (res.data["message"] is String) {
          snackBar.showSnackbar(message: res.data["message"]);
          return RegistrationResult.failure; // Return failure since it's an error message
        }
        else if (res.data["message"] is List<String>) {
          snackBar.showSnackbar(message: res.data["message"].join('\n'));
          return RegistrationResult.failure; // Return failure since it's an error message
        } else {
          // Handle unexpected data type (e.g., it's not a string or list)
          snackBar.showSnackbar(message: "Unexpected response format");
          return RegistrationResult.failure;
        }

      }
    } catch (e) {
      log.e(e);
      setBusy(false);
      return RegistrationResult.failure;

    }

  }

  Future<void> submitOtp() async {
    setBusy(true);

    try {
      ApiResponse res = await repo.submitOtp({
        "userId": profile.value.id,
        "verificationCode": otp.text,
      });
      isLoading =false;
      if (res.statusCode == 200) {
        snackBar.showSnackbar(message: 'OTP verified successfully', duration: Duration(seconds: 5));
        // print(res);
        // isOtpRequested = true;
        // notifyListeners();
        // isLoading =false;
        locator<NavigationService>().clearStackAndShow(Routes.registerView);

      }
      else {
        isLoading =false;
        snackBar.showSnackbar(message: res.data["message"], duration: Duration(seconds: 5));
        setBusy(false);
      }
    } catch (e) {
      log.i(e);
      setBusy(false);
      isLoading =false;

    }

    setBusy(false);
  }


  void requestOtp() async {
    setBusy(true);

    try {
      ApiResponse res = await repo.requestOtp({

        "email": email.text,
      });
      if (res.statusCode == 200) {
        snackBar.showSnackbar(message: 'OTP successfully sent', duration: Duration(seconds: 5));
        print(res);
        print(res.data['data']["userId"]);

        profile.value.id = res.data['data']["userId"];
        isOtpRequested = true;
        notifyListeners();
      }else {
        snackBar.showSnackbar(message: res.data["message"], duration: Duration(seconds: 5));
        setBusy(false);
      }
    } catch (e) {
      log.i(e);
      setBusy(false);

    } finally {
      setBusy(false);
    }

    setBusy(false);
  }


}
