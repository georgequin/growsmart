import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';

import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Background(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0 ,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Image.asset(
                "assets/images/logo_splash.png",
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());
}
