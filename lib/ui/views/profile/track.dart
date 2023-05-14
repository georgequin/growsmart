import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:casa_vertical_stepper/casa_vertical_stepper.dart';
import 'package:flutter/material.dart';

import '../../common/app_colors.dart';

class Track extends StatefulWidget {
  const Track({Key? key}) : super(key: key);

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Tracking",
          style: TextStyle(color: kcBlackColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 90,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E2E2), width: 1.5),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/track.png"))),
                ),
                horizontalSpaceSmall,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Cotton shirt Regular Fit"),
                    Text(
                      "\$20",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
          verticalSpaceLarge,
          const Text(
            "Track Order",
            style: TextStyle(fontSize: 18),
          ),
          verticalSpaceMedium,
          CasaVerticalStepperView(steps: [
            StepperStep(
              leading: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                    color: Color(0xFFFFB000), shape: BoxShape.circle),
                child: const Center(
                  child: Icon(
                    Icons.edit_note,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Order Placed",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kcMediumGrey,
                    ),
                  ),
                  Text("We have received your order"),
                ],
              ),
              view: Container(
                height: 40,
              ),
            ),
            StepperStep(
              leading: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                    color: Color(0xFFFFB000), shape: BoxShape.circle),
                child: const Center(
                  child: Icon(
                    Icons.edit_note,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Order Processed",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kcMediumGrey,
                    ),
                  ),
                  Text("We have received your order"),
                ],
              ),
              view: Container(
                height: 40,
              ),
            ),
            StepperStep(
              leading: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                    color: kcMediumGrey, shape: BoxShape.circle),
                child: const Center(
                  child: Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Ready to ship",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kcMediumGrey,
                    ),
                  ),
                  Text("Your order is ready for shipping"),
                ],
              ),
              view: Container(
                height: 40,
              ),
            ),
            StepperStep(
              leading: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                    color: kcMediumGrey, shape: BoxShape.circle),
                child: const Center(
                  child: Icon(
                    Icons.fire_truck,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Out for delivery",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kcMediumGrey,
                    ),
                  ),
                  Text("Your order is out for delivery"),
                ],
              ),
              view: Container(
                height: 40,
              ),
            ),
            StepperStep(
              leading: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                    color: kcMediumGrey, shape: BoxShape.circle),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Out for delivery",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kcMediumGrey,
                    ),
                  ),
                  Text("Your order has been delivered"),
                ],
              ),
              view: Container(
                height: 0,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
