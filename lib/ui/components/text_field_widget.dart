import 'package:afriprize/ui/common/app_colors.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String? label;
  final String hint;
  final TextEditingController controller;
  final Function? validator;
  final Widget? suffix;
  final Widget? leading;
  final bool obscureText;
  final TextInputType? inputType;
  final bool readOnly;

  const TextFieldWidget(
      {Key? key,
      this.label,
      this.validator,
      this.inputType,
      required this.hint,
      required this.controller,
      this.readOnly = false,
      this.obscureText = false,
      this.leading,
      this.suffix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      cursorColor: kcBlackColor,
      style: const TextStyle(color: kcBlackColor, fontSize: 14),
      validator: validator as String? Function(String?)?,
      obscureText: obscureText,
      keyboardType: inputType,
      decoration: InputDecoration(
        filled: true,
        fillColor: kcWhiteColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kcBlackColor.withOpacity(0.22)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kcBlackColor.withOpacity(0.22)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kcBlackColor.withOpacity(0.22)),
        ),
        labelText: hint,
        labelStyle: const TextStyle(color: kcBlackColor, fontSize: 14),
        prefixIcon: leading == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: leading,
              ),
        suffixIcon: suffix == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: suffix,
              ),
      ),
    );
  }
}
