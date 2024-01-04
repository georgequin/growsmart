

import 'package:stacked_services/stacked_services.dart';

import '../app/app.dialogs.dart';
import '../app/app.locator.dart';


Future<DialogResponse?> showDialog(String title, String? description, bool isDialogBeingDisplayed) async {
  if (!isDialogBeingDisplayed) {
    isDialogBeingDisplayed = true;
    DialogResponse? res = await locator<DialogService>().showCustomDialog(
      variant: DialogType.infoAlert,
      title: title,
      description: description,
    );
    isDialogBeingDisplayed = false;
    return res;
  }
  return null;
}