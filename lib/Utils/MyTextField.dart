import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final bool? isPhonenumber;
  final bool? isEmail;
  const Mytextfield(
      {super.key,
      this.fontSize,
      this.iconButton,
      this.onTap,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.multiLine,
      this.isEmail,
      this.isPhonenumber,
      this.hintColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    if (iconButton == null) {
      return TextField(
        cursorColor: (textColor == null) ? Colors.white : textColor,
        keyboardType: isEmail == true
            ? TextInputType.emailAddress
            : isPhonenumber == true
                ? TextInputType.number
                : TextInputType.text,
        inputFormatters: [
          if (isEmail == true)
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9.]')),
          if (isEmail == true) LengthLimitingTextInputFormatter(30),
          if (isPhonenumber == true) FilteringTextInputFormatter.digitsOnly,
          if (isPhonenumber == true) LengthLimitingTextInputFormatter(10),
        ],
        maxLines: (multiLine ?? false) ? null : 1,
        style: TextStyle(
          color: (textColor == null) ? Colors.white : textColor,
        ),
        decoration: InputDecoration(
            suffixText: isEmail == true ? "@iiitg.ac.in" : null,
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
