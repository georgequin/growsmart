import 'package:flutter/cupertino.dart';
import 'package:easy_power/app/app.locator.dart';
import 'package:easy_power/app/app.router.dart';
import 'package:easy_power/ui/common/app_colors.dart';
import 'package:easy_power/ui/common/ui_helpers.dart';
import 'package:easy_power/ui/components/submit_button.dart';
import 'package:easy_power/ui/components/text_field_widget.dart';
import 'package:easy_power/ui/views/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'SignUp.dart';
import 'auth_view.dart';


/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///


class Login extends StatefulWidget {
  final Function(PresentPage) updateIsLogin;
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
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kcPrimaryColor,
                      ),
                    ),
                    verticalSpaceTiny,
                    Text(
                      "Welcome back you’ve been missed!",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

          verticalSpaceTiny,

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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // InkWell(
                  //   onTap: model.toggleRemember,
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //           height: 20,
                  //           width: 20,
                  //           decoration: BoxDecoration(
                  //               color: model.remember
                  //                   ? kcSecondaryColor
                  //                   : Colors.transparent,
                  //               borderRadius: BorderRadius.circular(5),
                  //               border: Border.all(
                  //                   color: model.remember
                  //                       ? Colors.transparent
                  //                       : kcSecondaryColor)),
                  //           child: model.remember
                  //               ? const Center(
                  //             child: Icon(
                  //               Icons.check,
                  //               color: kcWhiteColor,
                  //               size: 14,
                  //             ),
                  //           )
                  //               : const SizedBox()),
                  //       horizontalSpaceSmall,
                  //       const Text(
                  //         "Remember Me",
                  //         style: TextStyle(
                  //             fontSize: 14, decoration: TextDecoration.underline),
                  //       )
                  //     ],
                  //   ),
                  // ),
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
              verticalSpaceMedium,
              SubmitButton(
                isLoading: model.isBusy,
                boldText: true,
                label: "Login",
                submit: () {
                  //locator<NavigationService>().clearStackAndShow(Routes.homeView);
                  model.login();
                },
                color: kcPrimaryColor,
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
              //   color: Colors.grey,
              // ),

              verticalSpaceMedium,

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {

                        widget.updateIsLogin(PresentPage.signup);
                        //gotoRegister();

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
            ],
          ),
        ),
      ),
    );
  }

}
