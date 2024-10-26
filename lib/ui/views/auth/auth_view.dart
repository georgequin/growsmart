import 'package:afriprize/ui/views/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/app_colors.dart';
import 'SignUp.dart';
import 'login.dart';

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
          getPageWidget(), // Directly load the page here without additional container
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
