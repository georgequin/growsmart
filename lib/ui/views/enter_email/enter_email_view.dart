import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/components/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'enter_email_viewmodel.dart';

class EnterEmailView extends StackedView<EnterEmailViewModel> {
  const EnterEmailView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    EnterEmailViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Input Your Email Address",
              style: TextStyle(),
            ),
            verticalSpaceMedium,
            TextFieldWidget(
                hint: "Enter Email", controller: TextEditingController()),
            verticalSpaceMedium,
            SubmitButton(
              isLoading: viewModel.isBusy,
              label: "Continue",
              submit: viewModel.sendCode,
              color: kcPrimaryColor,
            )
          ],
        ),
      ),
    );
  }

  @override
  EnterEmailViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      EnterEmailViewModel();
}
