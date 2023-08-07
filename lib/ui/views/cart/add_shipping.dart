import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/core/data/models/profile.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/components/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../components/drop_down_widget.dart';

class AddShipping extends StatefulWidget {
  const AddShipping({Key? key}) : super(key: key);

  @override
  State<AddShipping> createState() => _AddShippingState();
}

class _AddShippingState extends State<AddShipping> {
  final address = TextEditingController();
  String? state;
  final city = TextEditingController();
  final phone = TextEditingController();
  final zipCode = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Shipping Details"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFieldWidget(
            hint: "Street Address",
            controller: address,
          ),
          verticalSpaceMedium,
          DropdownWidget(
            value: state,
            itemsList: states,
            hint: "State",
            onChanged: (value) {
              setState(() {
                state = value;
              });
            },
          ),
          verticalSpaceMedium,
          TextFieldWidget(
            hint: "City",
            controller: city,
          ),
          verticalSpaceMedium,
          TextFieldWidget(
            hint: "Phone",
            controller: phone,
          ),
          verticalSpaceMedium,
          TextFieldWidget(
            hint: "Zip Code",
            controller: zipCode,
          ),
          verticalSpaceMedium,
          SubmitButton(
            isLoading: isLoading,
            label: "Submit",
            submit: () async {
              if (state == null) {
                return;
              }
              if (!isLoading) {
                setState(() {
                  isLoading = true;
                });

                try {
                  ApiResponse res = await locator<Repository>().saveShipping({
                    "shipping_firstname": profile.value.firstname,
                    "shipping_lastname": profile.value.lastname,
                    "shipping_phone": "+234${phone.text.substring(1)}",
                    "shipping_additional_phone":
                        "+234${profile.value.phone?.substring(1)}",
                    "shipping_address": address.text,
                    "shipping_additional_address": address.text,
                    "shipping_state": state,
                    "shipping_city": city.text,
                    "shipping_zip_code": int.parse(zipCode.text)
                  });
                  if (res.statusCode == 200) {
                    locator<SnackbarService>()
                        .showSnackbar(message: res.data["message"]);
                    ApiResponse pRes = await locator<Repository>().getProfile();
                    if (pRes.statusCode == 200) {
                      profile.value = Profile.fromJson(
                          Map<String, dynamic>.from(pRes.data["user"]));
                      profile.notifyListeners();
                    }
                    Navigator.pop(context);
                  } else {
                    if (res.data["message"].runtimeType
                        .toString()
                        .toLowerCase()
                        .contains("list")) {
                      for (var element in (res.data["message"] as List)) {
                        locator<SnackbarService>()
                            .showSnackbar(message: element);
                      }
                    } else {
                      locator<SnackbarService>()
                          .showSnackbar(message: res.data["message"]);
                    }
                  }
                } catch (e) {
                  print(e);
                }

                setState(() {
                  isLoading = false;
                });
              }
            },
            color: kcPrimaryColor,
          )
        ],
      ),
    );
  }
}

List<String> states = [
  "Abia",
  "Adamawa",
  "Akwa Ibom",
  "Anambra",
  "Bauchi",
  "Bayelsa",
  "Benue",
  "Borno",
  "Cross River",
  "Delta",
  "Ebonyi",
  "Edo",
  "Ekiti",
  "Enugu",
  "FCT - Abuja",
  "Gombe",
  "Imo",
  "Jigawa",
  "Kaduna",
  "Kano",
  "Katsina",
  "Kebbi",
  "Kogi",
  "Kwara",
  "Lagos",
  "Nasarawa",
  "Niger",
  "Ogun",
  "Ondo",
  "Osun",
  "Oyo",
  "Plateau",
  "Rivers",
  "Sokoto",
  "Taraba",
  "Yobe",
  "Zamfara"
];
