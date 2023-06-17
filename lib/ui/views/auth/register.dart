import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/drop_down_widget.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/components/text_field_widget.dart';
import 'package:afriprize/ui/views/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/ui_helpers.dart';

class Register extends StatefulWidget {
  final TabController controller;

  const Register({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      viewModelBuilder: () => AuthViewModel(),
      builder: (context, model, child) => ListView(
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
            hint: "Firstname",
            controller: model.firstname,
          ),
          verticalSpaceSmall,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
                "Firstname must correspond with your bank details to process a successful withdrawal."),
          ),
          verticalSpaceMedium,
          TextFieldWidget(
            hint: "Lastname",
            controller: model.lastname,
          ),
          verticalSpaceSmall,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
                "Lastname must correspond with your bank details to process a successful withdrawal."),
          ),
          verticalSpaceMedium,
          TextFieldWidget(
            hint: "Email id",
            controller: model.email,
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
            controller: model.phone,
          ),
          verticalSpaceSmall,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
                "A valid number is required for pin resetting and withdrawal requests"),
          ),
          // verticalSpaceMedium,
          // DropdownWidget(
          //   value: null,
          //   itemsList: const ["Nigeria", "Uk", "Canada"],
          //   onChanged: (v) {},
          //   hint: "Select country",
          // ),
          verticalSpaceSmall,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Select your country",
            ),
          ),
          verticalSpaceMedium,
          TextFieldWidget(
            hint: "Password",
            controller: model.password,
            obscureText: model.obscure,
            suffix: InkWell(
              onTap: () {
                model.toggleObscure();
              },
              child:
                  Icon(model.obscure ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          verticalSpaceSmall,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Password must be between 6 - 8 characters"),
          ),
          verticalSpaceMedium,
          TextFieldWidget(
            hint: "Confirm password",
            controller: model.cPassword,
            obscureText: model.obscure,
            suffix: InkWell(
              onTap: () {
                model.toggleObscure();
              },
              child:
                  Icon(model.obscure ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          verticalSpaceSmall,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Password must be between 6 - 8 characters"),
          ),
          verticalSpace(60),
          InkWell(
            onTap: model.toggleTerms,
            child: Row(
              children: [
                Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color:
                            model.terms ? kcSecondaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: model.terms
                                ? Colors.transparent
                                : kcSecondaryColor)),
                    child: model.terms
                        ? const Center(
                            child: Icon(
                              Icons.check,
                              color: kcWhiteColor,
                              size: 14,
                            ),
                          )
                        : const SizedBox()),
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
            isLoading: model.isBusy,
            label: "Register",
            submit: () => model.register(widget.controller),
            color: kcPrimaryColor,
            boldText: true,
          ),
          verticalSpaceMassive
        ],
      ),
    );
  }
}
