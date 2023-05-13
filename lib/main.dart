import 'package:flutter/material.dart';
import 'package:afriprize/app/app.bottomsheets.dart';
import 'package:afriprize/app/app.dialogs.dart';
import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';

void main() {
  setupLocator();
  setupDialogUi();
  setupBottomSheetUi();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          titleTextStyle:
              GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
          iconTheme: const IconThemeData(color: kcBlackColor),
          toolbarTextStyle: const TextStyle(color: kcBlackColor),
          backgroundColor: kcWhiteColor,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        primaryColor: kcBackgroundColor,
        focusColor: kcPrimaryColor,
        textTheme:
            GoogleFonts.poppinsTextTheme().apply(bodyColor: kcBlackColor),
      ),
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        StackedService.routeObserver,
      ],
    );
  }
}
