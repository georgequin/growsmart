import 'package:flutter/material.dart';

class GenderWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final List<String> genderOptions; // Add this property

  const GenderWidget({super.key,
    required this.controller,
    required this.hint,
    required this.genderOptions,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: controller.text,
      onChanged: (value) {
        controller.text = value!;
      },
      items: genderOptions.map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      decoration: InputDecoration(
        hintText: hint,
        labelText: 'Gender',
      ),
      validator: validator,
    );
  }
}
