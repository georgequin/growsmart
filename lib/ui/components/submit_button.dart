import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final bool isLoading;
  final String label;
  final Function() submit;
  final Color color;
  final Color textColor;
  final bool boldText;
  final IconData? icon;
  final Color? iconColor;
  final bool iconIsPrefix;
  final bool buttonDisabled;

  const SubmitButton(
      {Key? key,
      required this.isLoading,
      required this.label,
      required this.submit,
      required this.color,
      this.icon,
      this.iconColor,
      this.textColor = Colors.white,
      this.boldText = false,
      this.iconIsPrefix = false,
      this.buttonDisabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonDisabled
          ? null
          : isLoading
              ? () {}
              : submit,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.15),
          color: buttonDisabled
              ? Colors.grey[600]
              : isLoading
                  ? color.withOpacity(0.7)
                  : color,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ),
                )
              : icon != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        iconIsPrefix
                            ? Row(
                                children: [
                                  Icon(
                                    icon,
                                    color: iconColor ?? Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              )
                            : const SizedBox(),
                        Text(
                          label,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight:
                                boldText ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        iconIsPrefix
                            ? const SizedBox()
                            : Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Icon(
                                    icon,
                                    color: iconColor ?? Colors.white,
                                  ),
                                ],
                              )
                      ],
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight:
                            boldText ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
        ),
      ),
    );
  }
}
