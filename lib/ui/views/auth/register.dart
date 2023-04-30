import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/drop_down_widget.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/components/text_field_widget.dart';
import 'package:flutter/material.dart';

import '../../common/ui_helpers.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text(
          "Register",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        verticalSpaceSmall,
        const Text(
          "Let’s get you started!",
          style: TextStyle(fontSize: 18),
        ),
        verticalSpaceMedium,
        TextFieldWidget(
          hint: "Surname",
          controller: TextEditingController(),
        ),
        verticalSpaceSmall,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
              "Surname must correspond with your bank details to process a successful withdrawal."),
        ),
        verticalSpaceMedium,
        TextFieldWidget(
          hint: "Input other name",
          controller: TextEditingController(),
        ),
        verticalSpaceSmall,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
              "Other names must correspond with your bank details to process a successful withdrawal."),
        ),
        verticalSpaceMedium,
        TextFieldWidget(
          hint: "Email id",
          controller: TextEditingController(),
        ),
        verticalSpaceSmall,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
              "A valid email is required for pin resetting and withdrawal requests"),
        ),
        verticalSpaceMedium,
        TextFieldWidget(
          hint: "Phone number",
          controller: TextEditingController(),
        ),
        verticalSpaceSmall,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
              "A valid number is required for pin resetting and withdrawal requests"),
        ),
        verticalSpaceMedium,
        DropdownWidget(
          value: null,
          itemsList: [],
          onChanged: (v) {},
          hint: "Select country",
        ),
        verticalSpaceSmall,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
              "Other names must correspond with your bank details to process a successful withdrawal."),
        ),
        verticalSpaceMedium,
        TextFieldWidget(
          hint: "Password",
          controller: TextEditingController(),
        ),
        verticalSpaceSmall,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Password must be between 6 - 8 characters"),
        ),
        verticalSpaceMedium,
        TextFieldWidget(
          hint: "Confirm password",
          controller: TextEditingController(),
        ),
        verticalSpaceSmall,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Password must be between 6 - 8 characters"),
        ),
        verticalSpace(60),
        InkWell(
          onTap: () {
            // setState(() {
            //   terms = !terms;
            // });
          },
          child: Row(
            children: [
              Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: kcSecondaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: kcWhiteColor,
                      size: 14,
                    ),
                  )),
              horizontalSpaceSmall,
              const Text(
                "I ACCEPT TERMS & CONDITIONS",
                style: TextStyle(
                    color: kcMediumGrey,
                    fontSize: 14,
                    decoration: TextDecoration.underline),
              )
            ],
          ),
        ),
        verticalSpaceMedium,
        SubmitButton(
          isLoading: false,
          label: "Register",
          submit: () {},
          color: kcPrimaryColor,
          boldText: true,
        ),
        verticalSpaceMassive
      ],
    );
  }
}
