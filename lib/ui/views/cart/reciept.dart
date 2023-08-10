import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Receipt extends StatefulWidget {
  final Map<String, dynamic> info;
  final int totalAmount;

  const Receipt({
    required this.info,
    required this.totalAmount,
    Key? key,
  }) : super(key: key);

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 180,
                width: MediaQuery.of(context).size.width,
                color: kcWhiteColor,
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 80,
                child: Container(
                  padding: const EdgeInsets.all(50),
                  height: 600,
                  decoration: const BoxDecoration(
                    color: kcWhiteColor,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "assets/images/reciept_bg.png",
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      verticalSpaceSmall,
                      const Text(
                        "Payment Success!",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kcWhiteColor),
                      ),
                      verticalSpaceSmall,
                      Text(
                        "Your payment has been successfully done.",
                        style: TextStyle(color: kcWhiteColor.withOpacity(0.72)),
                      ),
                      verticalSpaceSmall,
                      Divider(
                        color: kcWhiteColor.withOpacity(0.16),
                        thickness: 1,
                      ),
                      verticalSpaceSmall,
                      Text(
                        "Total Payment",
                        style: TextStyle(color: kcWhiteColor.withOpacity(0.72)),
                      ),
                      verticalSpaceSmall,
                      Text(
                        "N${widget.totalAmount}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kcWhiteColor),
                      ),
                      verticalSpaceMedium,
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: kcWhiteColor.withOpacity(0.16),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Draw ticket Number",
                                    style: TextStyle(
                                        color: kcWhiteColor.withOpacity(0.72),
                                        fontSize: 12),
                                  ),
                                  Text(
                                    "${widget.info["id"]}",
                                    style: const TextStyle(
                                        color: kcWhiteColor, fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                          horizontalSpaceSmall,
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: kcWhiteColor.withOpacity(0.16),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Payment Time",
                                    style: TextStyle(
                                        color: kcWhiteColor.withOpacity(0.72),
                                        fontSize: 12),
                                  ),
                                  Text(
                                    DateFormat("d MMM y, h:m").format(
                                        DateTime.parse(widget.info["created"])),
                                    //"25 Feb 2023, 13:22",
                                    style: const TextStyle(
                                        color: kcWhiteColor, fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: kcWhiteColor.withOpacity(0.16),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Payment Method",
                                    style: TextStyle(
                                        color: kcWhiteColor.withOpacity(0.72),
                                        fontSize: 12),
                                  ),
                                  const Text(
                                    "Wallet",
                                    style: TextStyle(
                                        color: kcWhiteColor, fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                          horizontalSpaceSmall,
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: kcWhiteColor.withOpacity(0.16),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sender Name",
                                    style: TextStyle(
                                        color: kcWhiteColor.withOpacity(0.72),
                                        fontSize: 12),
                                  ),
                                  const Text(
                                    "",
                                    // "${widget.info["user"]["firstname"]} ${widget.info["user"]["lastname"]}",
                                    style: TextStyle(
                                        color: kcWhiteColor, fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceLarge,
                      Image.asset("assets/images/logo.png")
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 60,
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      color: const Color(0xFF25282E),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 5.96),
                            blurRadius: 15.9,
                            color: const Color(0xFF000000).withOpacity(0.16))
                      ]),
                  child: Center(
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: kcSecondaryColor,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: kcBlackColor,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          verticalSpaceSmall,
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.download),
              horizontalSpaceSmall,
              Text("Get PDF Receipt"),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Close"),
          )
        ],
      ),
    );
  }
}
