import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../state.dart';
import '../../../utils/code_input.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import '../../components/submit_button.dart';
import '../../components/text_field_widget.dart';
import 'auth_view.dart';
import 'auth_viewmodel.dart';


/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///



class SignUp extends StatefulWidget {
  final Function(PresentPage) updatePage; // Ensure this is defined
  const SignUp({Key? key, required this.updatePage}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool terms = false;
  bool isPhoneNumber = false;


  @override
  void dispose() {
    super.dispose();
    appLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ViewModelBuilder<AuthViewModel>.reactive(
          onViewModelReady: (model) {
            model.init();
          },
          viewModelBuilder: () => AuthViewModel(),
          builder: (context, model, child) => ListView(
            children: [
               Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    verticalSpaceMassive,
                    Text(
                      model.isOtpRequested ?"Input OTP": "Create account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kcPrimaryColor,
                      ),
                    ),
                    verticalSpaceTiny,
                    Text(
                     model.isOtpRequested? "Please enter the code sent to your email or phone" :"Create an account so you can explore our high-quality products,",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              verticalSpaceMedium,
              if(!model.isOtpRequested)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: isPhoneNumber ? model.phone : model.email, // A single controller for both
                    decoration: InputDecoration(
                      hintText: isPhoneNumber
                          ? "Enter phone number"
                          : "Enter email or Phone",
                      prefixText: isPhoneNumber ? "+234 " : null, // Default to Nigeria
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType:
                    isPhoneNumber ? TextInputType.phone : TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        if (value.isNotEmpty && RegExp(r'^\d').hasMatch(value)) {
                          isPhoneNumber = true;
                          isLoginByEmail.value = false;
                          model.email.clear();
                        } else {
                          isPhoneNumber = false;
                          model.phone.clear();
                          isLoginByEmail.value = true;
                        }
                      });
                    },
                  ),
                ),
              verticalSpaceMedium,
              if(model.isOtpRequested)
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: CodeInputWidget(
                    codeController: model.otp,
                    onCompleted: (String value) {
                      model.submitOtp();
                    },
                  ),
                ),
              verticalSpaceSmall,
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SubmitButton(
                  isLoading: appLoading.value,
                  boldText: true,
                  label: model.isOtpRequested ? 'Verify OTP' : 'Get OTP',
                  submit: () {
                    setState(() {
                      model.isOtpRequested ? model.submitOtp() : model.requestOtp();
                    });
                  },
                  color: kcPrimaryColor,
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text(
                      "Already a user? ",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('why are you not working');
                        widget.updatePage(PresentPage.login);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 14,
                          color: kcSecondaryColor,
                        ),
                      ),
                    )

                  ]
              ),
              // Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children:  [
              //       const Text(
              //         "Resend OTP  ",
              //         style: TextStyle(
              //           fontSize: 12,
              //         ),
              //       ),
              //       GestureDetector(
              //         onTap: () {
              //          // gotoRegister();
              //
              //         },
              //         child: const Text(
              //           "(00:30)",
              //           style: TextStyle(
              //             fontSize: 12,
              //             color: kcSecondaryColor,
              //           ),
              //         ),
              //       )
              //
              //     ]
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void gotoRegister() {
  }
}
