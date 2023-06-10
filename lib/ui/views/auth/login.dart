import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/components/text_field_widget.dart';
import 'package:afriprize/ui/views/home/home_view.dart';
import 'package:flutter/material.dart';
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
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
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
            controller: TextEditingController(),
          ),
          verticalSpaceMedium,
          TextFieldWidget(
            hint: "Password",
            controller: TextEditingController(),
          ),
          verticalSpaceLarge,
          SubmitButton(
            isLoading: false,
            boldText: true,
            label: "Login",
            submit: () {
              locator<NavigationService>()
                  .clearStackAndShowView(const HomeView());
            },
            color: kcPrimaryColor,
          ),
          verticalSpaceLarge,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    terms = !terms;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: kcSecondaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: terms
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                color: kcWhiteColor,
                                size: 14,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    horizontalSpaceSmall,
                    const Text(
                      "Remember Me",
                      style: TextStyle(color: kcMediumGrey, fontSize: 16),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  // locator<NavigationService>()
                  //     .navigateToForgotPasswordView();
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
        ],
      ),
    );
  }
}
