
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

import 'startup_viewmodel.dart';

/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Positioned(
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
