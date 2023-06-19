import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/drop_down_widget.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/components/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'withdraw_viewmodel.dart';

class WithdrawView extends StackedView<WithdrawViewModel> {
  const WithdrawView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    WithdrawViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(),
      body: viewModel.busy(viewModel.banks)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(30),
              children: [
                TextFieldWidget(
                  hint: "Amount",
                  controller: viewModel.amount,
                ),
                verticalSpaceLarge,
                const Text("Beneficiary"),
                verticalSpaceSmall,
                DropdownWidget(
                  value: viewModel.selectedBank,
                  itemsList: viewModel.banks.map((e) => e.name!).toList(),
                  hint: "Bank",
                  onChanged: viewModel.changeBank,
                ),
                verticalSpaceMedium,
                TextFieldWidget(
                  hint: "Account Number",
                  controller: viewModel.accountNumber,
                ),
                verticalSpaceMedium,
                TextFieldWidget(
                  hint: "Account Name",
                  controller: viewModel.accountName,
                ),
                verticalSpaceLarge,
                SubmitButton(
                  isLoading: viewModel.isBusy,
                  label: "Withdraw",
                  submit: viewModel.withdraw,
                  boldText: true,
                  color: kcPrimaryColor,
                )
              ],
            ),
    );
  }

  @override
  void onViewModelReady(WithdrawViewModel viewModel) {
    viewModel.getBanks();
    super.onViewModelReady(viewModel);
  }

  @override
  WithdrawViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      WithdrawViewModel();
}