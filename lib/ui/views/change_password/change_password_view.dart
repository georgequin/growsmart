import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import '../../components/submit_button.dart';
import '../../components/text_field_widget.dart';
import 'change_password_viewmodel.dart';

class ChangePasswordView extends StackedView<ChangePasswordViewModel> {
  final bool isResetPassword;

  const ChangePasswordView({
    this.isResetPassword = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChangePasswordViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar(
          //  title: const Text('Change password', style: TextStyle(color: Colors.black)),
          //   leading: InkWell(
          //     onTap: () {
          //       Navigator.of(context).pop();
          //     },
          //     child: const Icon(
          //       Icons.arrow_back_ios,
          //       color: kcBlackColor,
          //     ),
          //   ),
          // expandedHeight: 200,
          // flexibleSpace: Background(
          //   children: [
          //     Positioned(
          //       top: 30,
          //       left: 0,
          //       right: 0,
          //       bottom: 0,
          //       child: Padding(
          //         padding: const EdgeInsets.all(80.0),
          //         child: Image.asset("assets/images/afriprize_light.png"),
          //       ),
          //     )
          //   ],
          // ),
          //),
          SliverList(
              delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Forget Password',
                              style: TextStyle(color: kcPrimaryColor, fontSize: 30),
                            ),
                            verticalSpaceMedium,
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset('assets/images/password.png'),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Reset Your Password',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'SF Pro Text',
                                        // fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Please enter the Email associated with your account.',
                                    style: TextStyle(
                                      color: kcBlackColor,
                                      fontFamily: 'SF-Pro-Text-Font-Family',
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalSpaceMedium,
                      TextFieldWidget(
                          hint: "Enter Email", controller: viewModel.email),
                      verticalSpaceMedium,
                      viewModel.emailVerified
                          ? Column(
                              children: [
                                TextFieldWidget(
                                  hint: "Enter Code",
                                  controller: viewModel.code,
                                ),
                                isResetPassword
                                    ? const SizedBox()
                                    : Column(
                                        children: [
                                          verticalSpaceMedium,
                                          TextFieldWidget(
                                            obscureText: viewModel.obscure,
                                            hint: "Enter Old Password",
                                            controller: viewModel.oldPassword,
                                            suffix: InkWell(
                                              onTap: () {
                                                viewModel.toggleObscure();
                                              },
                                              child: Icon(viewModel.obscure
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                            ),
                                          ),
                                        ],
                                      ),
                                verticalSpaceMedium,
                                TextFieldWidget(
                                  obscureText: viewModel.obscure,
                                  hint: "Enter New Password",
                                  controller: viewModel.newPassword,
                                  suffix: InkWell(
                                    onTap: () {
                                      viewModel.toggleObscure();
                                    },
                                    child: Icon(viewModel.obscure
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                ),
                                verticalSpaceMedium,
                              ],
                            )
                          : const SizedBox(),
                      SubmitButton(
                        isLoading: viewModel.isBusy,
                        label: viewModel.emailVerified ? "Submit" : "GET OTP",
                        submit: () {
                          if (viewModel.emailVerified == false) {
                            viewModel.sendCode();
                          } else {
                            viewModel.changePassword(context, isResetPassword);
                          }
                        },
                        boldText: true,
                        color: kcPrimaryColor,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  @override
  ChangePasswordViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ChangePasswordViewModel();
}
