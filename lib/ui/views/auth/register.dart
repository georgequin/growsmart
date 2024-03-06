import 'package:afriprize/core/data/models/country.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/components/text_field_widget.dart';
import 'package:afriprize/ui/views/auth/auth_viewmodel.dart';
import 'package:afriprize/utils/country_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/country_picker_utils.dart';
import '../../common/ui_helpers.dart';


/**
 * @author George David
 * email: georgequin19@gmail.com
 * Feb, 2024
 **/


class Register extends StatefulWidget {
  // final TabController controller;
  final Function(bool) updateIsLogin;
  const Register({Key? key, required this.updateIsLogin}) : super(key: key);



  @override
  State<Register> createState() => _RegisterState();

}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Country> countries = [];
  final List<String> genderOptions = ['Male', 'Female'];

  bool? loadingCountries = true;

  @override
  void initState() {
    loadCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      viewModelBuilder: () => AuthViewModel(),
      builder: (context, model, child) =>
         loadingCountries == true ? const CircularProgressIndicator() :
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Panchang"
                  ),
                ),
                verticalSpaceTiny,
                Row(
                    children:  [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          gotoLogin();
                        },
                        child: const Text(
                          "login Account",
                          style: TextStyle(
                            fontSize: 12,
                            color: kcSecondaryColor,
                          ),
                        ),
                      )

                    ]
                ),
                verticalSpaceMedium,
                Row(
                  children: [
                    Expanded(
                      child: TextFieldWidget(
                        hint: "Firstname",
                        controller: model.firstname,
                        inputType: TextInputType.name,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'required';
                          }
                          return null; // Return null to indicate no validation error
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: TextFieldWidget(
                        hint: "Lastname",
                        controller: model.lastname,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'required';
                          }
                          return null; // Return null to indicate no validation error
                        },
                      ),
                    ),
                    verticalSpaceSmall,
                  ],
                ),
                verticalSpaceSmall,
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                      style: TextStyle(
                        fontSize: 11,
                      ),
                      "Matching names with bank details to process a successful withdrawal."),
                ),
                verticalSpaceMedium,
                TextFieldWidget(
                  hint: "Email Address",
                  controller: model.email,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'required';
                    }
                    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                      return 'Invalid email address';
                    }
                    return null; // Return null to indicate no validation error
                  },
                ),
                verticalSpaceSmall,
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                      style: TextStyle(
                        fontSize: 11,
                      ),
                      "A valid email is required for pin resetting and withdrawal requests"),
                ),
                verticalSpaceMedium,
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: const TextStyle(color: Colors.black,fontSize: 13),
                    floatingLabelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Add border curve
                      borderSide: const BorderSide(color: Color(0xFFCC9933)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Add border curve
                      borderSide: const BorderSide(color: Color(0xFFCC9933)),
                    ),
                  ),
                  validator: (value) {
                    if (value!.completeNumber.isEmpty) {
                      return 'required';
                    }
                    return null; // Return null to indicate no validation error
                  },
                  initialCountryCode: 'NG',
                  countries: countries.map((country) => CountryPickerUtils.getCountryByIsoCode(country.code!)).toList(),
                  controller: model.phone,
                  onChanged: (phone) {
                      model.phoneNumber = phone;
                      model.countryId = countries.firstWhere((country) => country.code == phone.countryISOCode).id!;
                  },
                ),
                //
                verticalSpaceSmall,
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    labelStyle: const TextStyle(color: Colors.black,fontSize: 13),
                    floatingLabelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Color(0xFFCC9933)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Color(0xFFCC9933)),
                    ),
                  ),
                  value: model.selectedGender, // You should add selectedGender to your model
                  onSaved: (String? newValue) {
                    model.selectedGender = newValue!;
                  },
                  onChanged: (String? newValue) {
                    model.selectedGender = newValue!;
                  },
                  items: genderOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Please select a gender' : null,
                ),
                verticalSpaceSmall,
                TextFieldWidget(
                  inputType: TextInputType.visiblePassword,
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'Password must contain at least one uppercase letter';
                    }
                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return 'Password must contain at least one lowercase letter';
                    }
                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return 'Password must contain at least one digit';
                    }
                    if (!RegExp(r'[!@#$%^&*]').hasMatch(value)) {
                      return 'Password must contain at least one special character';
                    }
                    return null; // Return null to indicate no validation error
                  },
                ),
                verticalSpaceSmall,
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text( style: TextStyle(
                    fontSize: 11,
                  ),
                      "Must be at least 8 characters with a combination of letters and numbers"),
                ),
                verticalSpaceMedium,
                TextFieldWidget(
                  hint: "Confirm password",
                  controller: model.cPassword,
                  obscureText: model.obscure,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password confirmation is required';
                    }
                    if (value != model.password.text) {
                      return 'Passwords do not match';
                    }
                    return null; // Return null to indicate no validation error
                  },
                  suffix: InkWell(
                    onTap: () {
                      model.toggleObscure();
                    },
                    child:
                        Icon(model.obscure ? Icons.visibility_off : Icons.visibility),
                  ),
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
                            fontSize: 12, decoration: TextDecoration.underline),
                      )
                    ],
                  ),
                ),
                verticalSpaceSmall,
                InkWell(
                  onTap: () async {
                    final Uri toLaunch =
                    Uri(scheme: 'https', host: 'www.afriprize.com', path: '/legal/privacy-policy');

                    if (!await launchUrl(toLaunch, mode: LaunchMode.inAppBrowserView)) {
                      throw Exception('Could not launch www.afriprize.com/legal/privacy-policy');
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "View our Privacy Policy",
                        style: TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                          color: kcSecondaryColor, // Feel free to change the color
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpaceSmall,
                const Text('Apple/Google is not a sponsor nor is involved in any way with our raffles/contest or sweepstakes.'),
                verticalSpaceMedium,
                SubmitButton(
                  isLoading: model.isBusy,
                  label: "Create Account",
                  submit: () {
                    if (_formKey.currentState!.validate()) {
                      model.register();
                    }
                  },
                  color: kcPrimaryColor,
                  boldText: true,
                ),

                // verticalSpaceMedium,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: const <Widget>[
                //     Expanded(
                //       child: Divider(
                //         color: Colors.grey,
                //         thickness: 1,
                //       ),
                //     ),
                //     Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 8),
                //       child: Text(
                //         "OR",
                //         style: TextStyle(
                //           fontSize: 14,
                //           color: Colors.grey,
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: Divider(
                //         color: Colors.grey,
                //         thickness: 1,
                //       ),
                //     ),
                //   ],
                // ),

                // verticalSpaceMedium,
                //
                // SubmitButton(
                //   isLoading: model.isBusy,
                //   boldText: true,
                //   iconIsPrefix: true,
                //   icon: FontAwesomeIcons.google,
                //   label: "Sign in with Google",
                //   textColor: Colors.black,
                //   submit: () {
                //     Fluttertoast.showToast(msg: 'Coming soon',
                //         toastLength: Toast.LENGTH_LONG
                //     );
                //   },
                //   color: Colors.grey,
                // ),

                verticalSpaceLarge,
                const SizedBox(
                  height: 50,
                ),
                verticalSpaceMassive
              ],
            ),
          ),
    );
  }

  void gotoLogin() {
    widget.updateIsLogin(true);
  }


  void loadCountries() async {
    try {
      setState(() {
        loadingCountries = true;
      });
      List<Country> countries = await CountryUtils().getSupportedCountries();
      setState(() {
        this.countries = countries;
        loadingCountries = false;
      });
    } catch (e) {
      setState(() {
        loadingCountries = false;
      });
    }
  }

}
