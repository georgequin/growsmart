import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:growsmart/ui/views/onboarding/onboading_view2.dart';
import 'package:growsmart/ui/views/onboarding/onboading_view3.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import '../../components/submit_button.dart';
import 'onboarding_viewmodel.dart';

class OnboardingView2 extends StatefulWidget {
  @override
  State<OnboardingView2> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background curved shape
            Align(
              alignment: Alignment.topCenter,
              child: ClipPath(
                clipper: CurvedClipper(),
                child: Container(
                  height: 500,
                  color: kcMediumGrey,
                ),
              ),
            ),
            // Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skip button
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle skip
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: kcDarkGreyColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    'assets/images/lightpic.svg',
                    height: 400,
                  ),
                ),



                verticalSpaceMassive,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "Explore Our Extensive Catalog",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "With a wide range of high-quality products, you can easily find and purchase the best power solutions for your needs—all in one place.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Page indicators
                      // Next button
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OnboardingView3()),
                          );
                        },
                        child: Row(
                          children: const [
                            Text(
                              "Next",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IndicatorDot(isActive: false),
                    const SizedBox(width: 8),
                    IndicatorDot(isActive: true),
                    const SizedBox(width: 8),
                    IndicatorDot(isActive: false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    // Start from top-left corner
    path.lineTo(0, size.height - 100);
    // Create a quadratic bezier curve
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 100,
    );
    // Line to the top-right corner
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class IndicatorDot extends StatelessWidget {
  final bool isActive;
  const IndicatorDot({super.key, required this.isActive});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: isActive ? Colors.orange : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

// class _OnboardingViewState extends State<OnboardingView> {
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<OnboardingViewModel>.reactive(
//       viewModelBuilder: () => OnboardingViewModel(),
//       onModelReady: (model) => model.init(),
//       builder: (context, model, child) {
//         return Scaffold(
//           body: Column(
//             children: [
//               Positioned(
//                 top: -250, // Adjust to move the circle upwards
//                 left: -250, // Adjust to move the circle leftwards
//                 child: Container(
//                   color: Color.fromARGB(255, 187, 187, 187),
//                   child: SizedBox(
//                     height: 500,
//                     child: Stack(
//                       clipBehavior: Clip.none, // Allow the circle to overflow
//                       children: [
//                         Positioned(
//                           top: 0,
//                           right: 0, // Position the circle to extend outside the right side
//                           left: 0,  // Position the circle to extend outside the left side
//                           child: Container(
//                             width: 1500, // Increased width for a larger circle
//                             height: 500, // Increased height to ensure the circle goes beyond the container
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(750), // Half of the width/height to make it a circle
//                               color: kcPrimaryColor.withOpacity(0.5),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//
//               // child: Column(
//               //   mainAxisAlignment: MainAxisAlignment.end,
//               //   children: [
//               //     Padding(
//               //       padding: const EdgeInsets.all(16.0),
//               //       child: Column(
//               //         children: <Widget>[
//               //           Align(
//               //             alignment: Alignment.topRight,
//               //             child: TextButton(
//               //               onPressed: () {
//               //                 // Handle skip action
//               //               },
//               //               child: Text('Skip', style: TextStyle(color: kcSecondaryColor),),
//               //             ),
//               //           ),
//               //           Center(
//               //             child: Padding(
//               //               padding: const EdgeInsets.all(10.0),
//               //               child: Image.asset('assets/images/welcome.png'),
//               //             ),
//               //           ),
//               //           const SizedBox(
//               //             height: 100,
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //   ],
//               // ),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         'Welcome to Easy Power Hub!',
//                         style: TextStyle(
//                           fontSize: 25,
//                           fontFamily: 'SF Pro Text',
//                           // fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     verticalSpaceSmall,
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text(
//                         'We’re excited to have you here. Browse our comprehensive selection of solar solutions, electronics, and lighting to find exactly what you need.',
//                         style: TextStyle(
//                           color: kcBlackColor,
//                           fontFamily: 'SF-Pro-Text-Font-Family',
//                           fontSize: 15,
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 80,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) {
//                                   return  OnboardingView2();
//                                 },
//                               ),
//                             );                          },
//                           child: Row(
//                             children: [
//                               Text(
//                                 'Next',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: kcPrimaryColor,
//                                   fontFamily: 'SF Pro Text',
//                                   // fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                               SizedBox(width: 5), // Space between text and icon
//                               Icon(
//                                 Icons.arrow_forward, // Next arrow icon
//                                 color: kcPrimaryColor,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     verticalSpaceMedium,
//                     verticalSpaceMedium,
//                     Center(
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: List.generate(3, (index) {
//                           return Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Container(
//                               width: 10.0,
//                               height: 10.0,
//                               decoration: BoxDecoration(
//                                 color: index == 0 ? kcPrimaryColor : Colors.grey,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//         );
//       },
//     );
//   }
// }
