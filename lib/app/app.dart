import 'package:afriprize/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:afriprize/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:afriprize/ui/views/cart/checkout.dart';
import 'package:afriprize/ui/views/cart/reciept.dart';
import 'package:afriprize/ui/views/dashboard/product_detail.dart';
import 'package:afriprize/ui/views/home/home_view.dart';
import 'package:afriprize/ui/views/profile/track.dart';
import 'package:afriprize/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afriprize/ui/views/onboarding/onboarding_view.dart';
import 'package:afriprize/ui/views/auth/auth_view.dart';
import 'package:afriprize/ui/views/dashboard/dashboard_view.dart';
import 'package:afriprize/ui/views/draws/draws_view.dart';
import 'package:afriprize/ui/views/cart/cart_view.dart';
import 'package:afriprize/ui/views/notification/notification_view.dart';
import 'package:afriprize/ui/views/profile/profile_view.dart';

import '../ui/views/profile/wallet.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: OnboardingView),
    MaterialRoute(page: AuthView),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: DrawsView),
    MaterialRoute(page: CartView),
    MaterialRoute(page: NotificationView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: Checkout),
    MaterialRoute(page: ProductDetail),
    MaterialRoute(page: Receipt),
    MaterialRoute(page: Wallet),
    MaterialRoute(page: Track),

// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
