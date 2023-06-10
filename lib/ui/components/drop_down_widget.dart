import 'package:afriprize/ui/common/app_colors.dart';
import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final value;
  final List<String> itemsList;
  final List<String>? assets;
  final String hint;
  final Function onChanged;

  const DropdownWidget({
    Key? key,
    required this.value,
    required this.itemsList,
    required this.hint,
    required this.onChanged,
    this.assets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      itemHeight: 52.0,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        filled: true,
        fillColor: kcWhiteColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kcBlackColor.withOpacity(0.22)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kcBlackColor.withOpacity(0.22)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kcBlackColor.withOpacity(0.22)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kcBlackColor.withOpacity(0.22)),
        ),
      ),
      dropdownColor: kcSecondaryColor,
      iconSize: 30,
      iconEnabledColor: kcPrimaryColor,
      iconDisabledColor: kcPrimaryColor,
      hint: Text(
        value ?? hint,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          color: kcBlackColor,
        ),
      ),
      value: value,
      items: itemsList.map((String value) {
        int index = itemsList.indexOf(value);

        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: [
              assets != null
                  ? Image.asset(
                      assets![index],
                      height: 20,
                      width: 20,
                    )
                  : const SizedBox(),
              const SizedBox(width: 5),
              Text(
                value,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) => onChanged(value),
    );
  }
}
