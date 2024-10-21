import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/components/text_field_widget.dart';
import 'package:afriprize/ui/views/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';


/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///


class Login extends StatefulWidget {
  final Function(bool) updateIsLogin;
  const Login({Key? key, required this.updateIsLogin}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool terms = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        body: ViewModelBuilder<AuthViewModel>.reactive(
          onViewModelReady: (model) {
            model.init();
          },
          viewModelBuilder: () => AuthViewModel(),
          builder: (context, model, child) => ListView(
            children: [
              const Text(
                "Login Account",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Panchang"
                ),
              ),
              verticalSpaceTiny,
          Row(
            children:  [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                      fontSize: 12,
                      ),
                ),
              GestureDetector(
                onTap: () {
                  gotoRegister();

                },
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 12,
                    color: kcSecondaryColor,
                  ),
                ),
              )

            ]
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
              verticalSpaceTiny,
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
                              fontSize: 14, decoration: TextDecoration.underline),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      locator<NavigationService>()
                          .navigateToEnterEmailView();
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
              SubmitButton(
                isLoading: model.isBusy,
                boldText: true,
                label: "Login Account",
                submit: () {
                  model.login();
                },
                color: kcSecondaryColor,
              ),
              // verticalSpaceMedium,
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: const <Widget>[
              //     Expanded(
              //       child: Divider(
              //         color: Colors.grey,
              //         thickness: 1,
              //       ),
              //     ),
              //     Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 8),
              //       child: Text(
              //         "OR",
              //         style: TextStyle(
              //           fontSize: 14,
              //           color: Colors.grey,
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: Divider(
              //         color: Colors.grey,
              //         thickness: 1,
              //       ),
              //     ),
              //   ],
              // ),
              //
              // verticalSpaceMedium,
              //
              // SubmitButton(
              //   isLoading: model.isBusy,
              //   boldText: true,
              //   iconIsPrefix: true,
              //   icon: FontAwesomeIcons.google,
              //   label: "Sign in with Google",
              //   textColor: Colors.black,
              //   submit: () {
              //     Fluttertoast.showToast(msg: 'Coming soon',
              //         toastLength: Toast.LENGTH_LONG
              //     );
              //   },
              //   color: kcLightGrey,
              // ),

              verticalSpaceLarge,
            ],
          ),
        ),
      ),
    );
  }

  void gotoRegister() {
    widget.updateIsLogin(false);
  }
}
