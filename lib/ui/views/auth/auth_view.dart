import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/background.dart';
import 'package:afriprize/ui/views/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../state.dart';
import 'auth_viewmodel.dart';
import 'login.dart';

class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AuthViewState();
  }
}

class _AuthViewState extends State<AuthView> with TickerProviderStateMixin {
  late TabController tabController;
  late List<Widget> _tabs;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    _tabs = [
      const Login(),
      const Register(),
    ];
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            flexibleSpace: Background(
              children: [
                Positioned(
                  top: 30,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Image.asset("assets/images/afriprize_light.png"),
                  ),
                )
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [

                Container(
                  padding: const EdgeInsets.all(25),
                  height: MediaQuery.of(context).size.height,  // Set a specific height constraint
                  child: Column(
                    children: const [
                      Flexible(
                        child: SingleChildScrollView(
                          child: Login(),
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.all(30),
                //   child: Column(
                //     children: const [
                //       Flexible(
                //         child: SingleChildScrollView(
                //           child: Login(),
                //         ),
                //       ),
                //       // Stack(
                //       //   children: [
                //       //
                //       //     // Positioned(
                //       //     //   bottom: 0,
                //       //     //   child: Container(
                //       //     //     height: 4,
                //       //     //     width: MediaQuery.of(context).size.width,
                //       //     //     color: kcVeryLightGrey,
                //       //     //   ),
                //       //     // ),
                //       //     // TabBar(
                //       //     //   controller: tabController,
                //       //     //   labelColor: kcSecondaryColor,
                //       //     //   unselectedLabelColor:
                //       //     //       uiMode.value == AppUiModes.light
                //       //     //           ? kcBlackColor
                //       //     //           : kcWhiteColor,
                //       //     //   indicatorWeight: 4,
                //       //     //   indicatorColor: kcSecondaryColor,
                //       //     //   tabs: const [
                //       //     //     Tab(
                //       //     //       text: "Login",
                //       //     //     ),
                //       //     //     Tab(
                //       //     //       text: "Register",
                //       //     //     )
                //       //     //   ],
                //       //     // ),
                //       //   ],
                //       // ),
                //       // SizedBox(
                //       //   height: MediaQuery.of(context).size.height / 1.7,
                //       //   child: TabBarView(
                //       //     controller: tabController,
                //       //     children: _tabs,
                //       //   ),
                //       // ),
                //     ],
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
