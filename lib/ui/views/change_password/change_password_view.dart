import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import '../../components/background.dart';
import '../../components/submit_button.dart';
import '../../components/text_field_widget.dart';
import 'change_password_viewmodel.dart';

class ChangePasswordView extends StackedView<ChangePasswordViewModel> {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChangePasswordViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: kcWhiteColor,
              ),
            ),
            expandedHeight: 200,
            flexibleSpace: Background(
              children: [
                Positioned(
                  top: 30,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset("assets/images/logo.png"),
                )
              ],
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(
            [
              Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpaceMassive,
                    const Text(
                      "Change Password",
                      style: TextStyle(fontSize: 18),
                    ),
                    verticalSpaceMedium,
                    TextFieldWidget(
                        hint: "Enter Email", controller: viewModel.email),
                    verticalSpaceSmall,
                    viewModel.emailVerified
                        ? Column(
                            children: [
                              TextFieldWidget(
                                hint: "Enter Code",
                                controller: viewModel.code,
                              ),
                              verticalSpaceSmall,
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
                              verticalSpaceSmall,
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
                              verticalSpaceSmall,
                            ],
                          )
                        : const SizedBox(),
                    SubmitButton(
                      isLoading: viewModel.isBusy,
                      label: viewModel.emailVerified ? "Submit" : "Continue",
                      submit: () {
                        if (viewModel.emailVerified == false) {
                          viewModel.sendCode();
                        } else {
                          viewModel.changePassword(context);
                        }
                      },
                      boldText: true,
                      color: kcPrimaryColor,
                    ),
                  ],
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
