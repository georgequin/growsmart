import 'package:stacked/stacked.dart';

class DashboardViewModel extends BaseViewModel {
  int selectedIndex = 0;

  void changeSelected(int i) {
    selectedIndex = i;
    rebuildUi();
  }
}
