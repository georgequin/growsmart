import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/core/data/models/order_item.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/components/text_field_widget.dart';
import 'package:awesome_rating/awesome_rating.dart';
import 'package:casa_vertical_stepper/casa_vertical_stepper.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/network/api_response.dart';
import '../../common/app_colors.dart';

// PENDING=1,
// PROCESSING=2,
// APPROVED=3,
// SHIPPED=4,
// DELIVERED=5,
// RECEIVED=6

class Track extends StatefulWidget {
  final OrderItem item;

  const Track({required this.item, Key? key}) : super(key: key);

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  double rating = 0;
  bool loading = false;
  final comment = TextEditingController();

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
                      image: widget.item.product?.pictures == null ||
                              widget.item.product!.pictures!.isEmpty
                          ? null
                          : DecorationImage(
                              image: NetworkImage(widget
                                  .item.product!.pictures![0].location!))),
                ),
                horizontalSpaceSmall,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${widget.item.product?.productName} (${widget.item.quantity})"),
                    Text(
                      "N${widget.item.quantity! * widget.item.product!.productPrice!}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                decoration: BoxDecoration(
                  color: widget.item.status == 1 ? kcOrangeColor : kcMediumGrey,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.edit_note,
                    color: Colors.white,
                  ),
                ),
              ),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Pending",
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
                decoration: BoxDecoration(
                    color:
                        widget.item.status == 2 ? kcOrangeColor : kcMediumGrey,
                    shape: BoxShape.circle),
                child: const Center(
                  child: Icon(
                    Icons.edit_note,
                    color: Colors.white,
                  ),
                ),
              ),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Processing",
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
                decoration: BoxDecoration(
                    color:
                        widget.item.status == 3 ? kcOrangeColor : kcMediumGrey,
                    shape: BoxShape.circle),
                child: const Center(
                  child: Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                  ),
                ),
              ),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Approved",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kcMediumGrey,
                    ),
                  ),
                  Text("Your order is approved"),
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
                decoration: BoxDecoration(
                    color:
                        widget.item.status == 4 ? kcOrangeColor : kcMediumGrey,
                    shape: BoxShape.circle),
                child: const Center(
                  child: Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                  ),
                ),
              ),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Shipped",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kcMediumGrey,
                    ),
                  ),
                  Text("Your order has been shipped"),
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
                decoration: BoxDecoration(
                    color:
                        widget.item.status == 5 ? kcOrangeColor : kcMediumGrey,
                    shape: BoxShape.circle),
                child: const Center(
                  child: Icon(
                    Icons.fire_truck,
                    color: Colors.white,
                  ),
                ),
              ),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order delivered",
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
                decoration: BoxDecoration(
                    color:
                        widget.item.status == 6 ? kcOrangeColor : kcMediumGrey,
                    shape: BoxShape.circle),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              ),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Received",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kcMediumGrey,
                    ),
                  ),
                  Text("Your order has received"),
                ],
              ),
              view: Container(
                height: 0,
              ),
            ),
          ]),
          verticalSpaceMedium,
          widget.item.status! >= 6
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Add review"),
                    verticalSpaceMedium,
                    TextFieldWidget(
                      hint: "Enter Comment",
                      controller: comment,
                    ),
                    verticalSpaceSmall,
                    Row(
                      children: [
                        const Text("Choose rating"),
                        horizontalSpaceMedium,
                        AwesomeStarRating(
                          starCount: 5,
                          rating: rating,
                          size: 30.0,
                          onRatingChanged: (double value) {
                            setState(() {
                              rating = value;
                            });
                          },
                          color: Colors.orange,
                          borderColor: Colors.orange,
                        ),
                      ],
                    ),
                    verticalSpaceMedium,
                    SubmitButton(
                      isLoading: loading,
                      label: "Rate",
                      submit: () async {
                        setState(() {
                          loading = true;
                        });

                        try {
                          ApiResponse res = await locator<Repository>()
                              .reviewOrder({
                            "orderId": widget.item.id,
                            "comment": comment.text,
                            "rating": rating.toInt()
                          });
                          if (res.statusCode == 200) {
                            locator<SnackbarService>()
                                .showSnackbar(message: res.data["message"]);
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          print(e);
                        }

                        setState(() {
                          loading = false;
                        });
                      },
                      color: kcPrimaryColor,
                    )
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
