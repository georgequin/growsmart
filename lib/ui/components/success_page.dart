
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/background.dart';
import 'package:flutter/material.dart';


/**
 * @author George David
 * email: georgequin19@gmail.com
 * Feb, 2024
 **/


class SuccessPage extends StatefulWidget {
  final String title;
  final String description;
  final Function callback;

  const SuccessPage({
    required this.title,
    required this.description,
    required this.callback,
    Key? key,
  }) : super(key: key);

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kcSecondaryColor),
                  ),
                  verticalSpaceSmall,
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: kcWhiteColor,
                    ),
                  ),
                  verticalSpaceMedium,
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kcWhiteColor)),
                    onPressed: () {
                      widget.callback();
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kcPrimaryColor,
                      ),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
