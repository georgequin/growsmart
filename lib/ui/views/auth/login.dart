import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/components/text_field_widget.dart';
import 'package:afriprize/ui/views/auth/auth_viewmodel.dart';
import 'package:afriprize/ui/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool terms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewModelBuilder<AuthViewModel>.reactive(
        onViewModelReady: (model) {
          model.init();
        },
        viewModelBuilder: () => AuthViewModel(),
        builder: (context, model, child) => ListView(
          // physics: const NeverScrollableScrollPhysics(),
          children: [
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            verticalSpaceMedium,
            const Text(
              "Enter your login information and have access to goodness!",
              style: TextStyle(fontSize: 18),
            ),
            verticalSpaceMedium,
            TextFieldWidget(
              hint: "Email",
              controller: model.email,
            ),
            verticalSpaceMedium,
            TextFieldWidget(
              hint: "Password",
              controller: model.password,
              obscureText: model.obscure,
              suffix: InkWell(
                onTap: () {
                  model.toggleObscure();
                },
                child: Icon(
                    model.obscure ? Icons.visibility_off : Icons.visibility),
              ),
            ),
            verticalSpaceLarge,
            SubmitButton(
              isLoading: model.isBusy,
              boldText: true,
              label: "Login",
              submit: () {
                model.login();
                // locator<NavigationService>()
                //     .clearStackAndShowView(const HomeView());
              },
              color: kcPrimaryColor,
            ),
            verticalSpaceLarge,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: model.toggleRemember,
                  child: Row(
                    children: [
                      Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              color: model.remember
                                  ? kcSecondaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: model.remember
                                      ? Colors.transparent
                                      : kcSecondaryColor)),
                          child: model.remember
                              ? const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: kcWhiteColor,
                                    size: 14,
                                  ),
                                )
                              : const SizedBox()),
                      horizontalSpaceSmall,
                      const Text(
                        "Remember Me",
                        style: TextStyle(
                            color: kcMediumGrey,
                            fontSize: 14,
                            decoration: TextDecoration.underline),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    locator<NavigationService>()
                        .navigateToChangePasswordView(isResetPassword: true);
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(
                      fontSize: 16,
                      color: kcSecondaryColor,
                    ),
                  ),
                )
              ],
            ),
            verticalSpaceLarge,
          ],
        ),
      ),
    );
  }
}
