import 'package:afriprize/core/utils/local_store_dir.dart';
import 'package:afriprize/core/utils/local_stotage.dart';
import 'package:stacked/stacked.dart';
import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 3));

    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic

    bool? onboarded =
        await locator<LocalStorage>().fetch(LocalStorageDir.onboarded);
    if (onboarded == null || onboarded == false) {
      _navigationService.replaceWithOnboardingView();
    } else {
      _navigationService.replaceWithHomeView();
      // _navigationService.replaceWithAuthView();
    }
  }
}
