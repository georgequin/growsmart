import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
                     model.isOtpRequested? "Please enter the code sent to your email ma*****@gmail.com" :"Create an account so you can explore our high-quality products,",
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
                child: TextFieldWidget(
                  hint: "Email Address",
                  controller: model.email,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'required';
                    }
                    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                      return 'Invalid email address';
                    }
                    return null; // Return null to indicate no validation error
                  },
                ),
              ),
              verticalSpaceMedium,
              if(model.isOtpRequested)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CodeInputWidget(
                    codeController: model.otp,
                    onCompleted: (String value) {
                      model.submitOtp();
                      if (model.isOtpRequested) {
                        widget.updatePage(PresentPage.register);
                      }
                    },
                  ),
                ),
              verticalSpaceSmall,
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SubmitButton(
                  isLoading: model.isBusy,
                  boldText: true,
                  label: model.isOtpRequested ? 'Verify OTP' : 'Get OTP',
                  submit: () {
                    model.isOtpRequested ? model.submitOtp() : model.requestOtp();
                    if (model.isOtpRequested) {
                      widget.updatePage(PresentPage.register);
                    }
                  },
                  color: kcPrimaryColor,
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text(
                      "Resend OTP  ",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                       // gotoRegister();

                      },
                      child: const Text(
                        "(00:30)",
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

  void gotoRegister() {
  }
}
