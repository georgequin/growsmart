import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_service.dart';
import 'package:afriprize/core/utils/local_stotage.dart';
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
import 'package:afriprize/ui/views/otp/otp_view.dart';
import 'package:afriprize/ui/views/change_password/change_password_view.dart';
import 'package:afriprize/ui/views/enter_email/enter_email_view.dart';
import 'package:afriprize/ui/views/delete_account/delete_account_view.dart';
import 'package:afriprize/ui/views/withdraw/withdraw_view.dart';
// @stacked-import

@StackedApp(
  logger: StackedLogger(),
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

    MaterialRoute(page: OtpView),
    MaterialRoute(page: ChangePasswordView),
    MaterialRoute(page: EnterEmailView),
    MaterialRoute(page: DeleteAccountView),
    MaterialRoute(page: WithdrawView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: ApiService),
    LazySingleton(classType: LocalStorage),
    LazySingleton(classType: Repository),
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
