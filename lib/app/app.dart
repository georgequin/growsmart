import 'package:growsmart/core/data/repositories/repository.dart';
import 'package:growsmart/core/network/api_service.dart';
import 'package:growsmart/core/utils/local_stotage.dart';
import 'package:growsmart/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:growsmart/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:growsmart/ui/views/home/home_view.dart';
import 'package:growsmart/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:growsmart/ui/views/onboarding/onboarding_view.dart';
import 'package:growsmart/ui/views/auth/auth_view.dart';
import 'package:growsmart/ui/views/dashboard/dashboard_view.dart';
import 'package:growsmart/ui/views/notification/notification_view.dart';
import 'package:growsmart/ui/views/profile/profile_view.dart';
import 'package:growsmart/ui/views/otp/otp_view.dart';
import 'package:growsmart/ui/views/change_password/change_password_view.dart';
import 'package:growsmart/ui/views/enter_email/enter_email_view.dart';
import 'package:growsmart/ui/views/delete_account/delete_account_view.dart';
import 'package:growsmart/ui/views/withdraw/withdraw_view.dart';
// @stacked-import
/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///

@StackedApp(
  logger: StackedLogger(),
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: OnboardingView),
    MaterialRoute(page: AuthView),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: NotificationView),
    MaterialRoute(page: ProfileView),

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
