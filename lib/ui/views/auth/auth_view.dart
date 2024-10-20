import 'package:easy_power/ui/views/auth/register.dart';
import 'package:flutter/material.dart';
import '../../common/app_colors.dart';
import 'login.dart';
import 'signup.dart'; // Import the SignUp page

/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///

enum PresentPage {
  login,
  register,
  signup,
}

class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AuthViewState();
  }
}

class _AuthViewState extends State<AuthView> with TickerProviderStateMixin {
  PresentPage presentPage = PresentPage.login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ClipPath(
              clipper: CurvedClipper(),
              child: Container(
                height: 300,
                color: kcMediumGrey,
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: const EdgeInsets.all(25),
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Flexible(
                            child: SingleChildScrollView(
                              child: getPageWidget(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getPageWidget() {
    switch (presentPage) {
      case PresentPage.login:
        return Login(
          updateIsLogin: (page) {
            setState(() {
              presentPage = page;
            });
          },
        );
      case PresentPage.signup:
        return SignUp(
          updatePage: (page) {  
            setState(() {
              presentPage = page;
            });
          },
        );
      case PresentPage.register:
        return Register(
          updateIsLogin: (page) {
            setState(() {
              presentPage = page ? PresentPage.login : PresentPage.signup;
            });
          },
        );
      default:
        return Container();
    }
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - 300);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 0,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
