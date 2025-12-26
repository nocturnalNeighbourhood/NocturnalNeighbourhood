import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Mytextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final double? fontSize;
  final IconData? iconButton;
  final Function()? onTap;
  final Color? hintColor;
  final Color? textColor;
  final bool? multiLine;
  const Mytextfield(
      {super.key,
      this.fontSize,
      this.iconButton,
      this.onTap,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.multiLine,
      this.hintColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    if (iconButton == null) {
      return TextField(
        maxLines: (multiLine ?? false) ? null : 1,
        style: TextStyle(
          color: (textColor == null) ? Colors.white : textColor,
        ),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(12)),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: fontSize,
              color: (hintColor == null)
                  ? Colors.white
                  : hintColor, //Theme.of(context).colorScheme.onSurface
            )),
        controller: controller,
        obscureText: obscureText,
      );
    } else {
      return TextField(
        style: TextStyle(
          color: (textColor == null) ? Colors.white : textColor,
        ),
        decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: onTap,
                icon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    iconButton,
                    color: Colors.white,
                  ),
                )),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(12)),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: fontSize,
              color: (hintColor == null)
                  ? Colors.white
                  : hintColor, //Theme.of(context).colorScheme.onSurface
            )),
        controller: controller,
        obscureText: obscureText,
      );
    }
  }
}
