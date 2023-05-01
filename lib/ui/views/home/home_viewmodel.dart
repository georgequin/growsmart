import 'package:afriprize/app/app.bottomsheets.dart';
import 'package:afriprize/app/app.dialogs.dart';
import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/ui/common/app_strings.dart';
import 'package:afriprize/ui/views/dashboard/dashboard_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  List<Widget> pages = [
    const DashboardView(),
    Container(),
    Container(),
    Container(),
    Container()
  ];

  String get counterLabel => 'Counter is: $_counter';

  int _counter = 0;
  int selectedTab = 0;

  void incrementCounter() {
    _counter++;
    rebuildUi();
  }

  void changeSelected(int i) {
    selectedTab = i;
    rebuildUi();
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      description: 'Give stacked $_counter stars on Github',
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }
}
