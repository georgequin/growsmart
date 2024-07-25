import 'package:growsmart/app/app.locator.dart';
import 'package:growsmart/app/app.logger.dart';
import 'package:growsmart/core/data/repositories/repository.dart';
import 'package:growsmart/core/network/api_response.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChangePasswordViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log = getLogger("EnterEmailViewModel");
  final email = TextEditingController();
  final code = TextEditingController();
  final newPassword = TextEditingController();
  final oldPassword = TextEditingController();
  final snackBar = locator<SnackbarService>();
  bool emailVerified = false;
  bool obscure = true;

  void toggleObscure() {
    obscure = !obscure;
    rebuildUi();
  }

  void sendCode() async {
    setBusy(true);

    try {
      ApiResponse res = await repo.resetPasswordRequest(email.text);
      if (res.statusCode == 200) {
        snackBar.showSnackbar(message: "Verification code sent");
        emailVerified = true;
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    }

    setBusy(false);
  }

  void changePassword(context, bool isResetPassword) async {
    setBusy(true);

    try {
      ApiResponse res = isResetPassword
          ? await repo.resetPassword(
              {
                "code": int.parse(code.text.toString()),
                "password": newPassword.text,
              },
              email.text,
            )
          : await repo.updatePassword(
              {
                // "code": int.parse(code.text.toString()),
                "oldpassword": oldPassword.text,
                "newpassword": newPassword.text,
              },
              email.text,
            );
      if (res.statusCode == 200) {
        snackBar.showSnackbar(message: "Updated");
        Navigator.pop(context);
      }
    } catch (e) {
      log.e(e);
    }

    setBusy(false);
  }
}
