import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Mytextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final double? fontSize;
  final IconData? iconButton;
  final Function()? onTap;
  const Mytextfield(
      {super.key,
      this.fontSize,
      this.iconButton,
      this.onTap,
      required this.hintText,
      required this.obscureText,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    if (iconButton == null) {
      return TextField(
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
              color: Colors.white, //Theme.of(context).colorScheme.onSurface
            )),
        controller: controller,
        obscureText: obscureText,
      );
    } else {
      return TextField(
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
              color: Colors.white, //Theme.of(context).colorScheme.onSurface
            )),
        controller: controller,
        obscureText: obscureText,
      );
    }
  }
}
