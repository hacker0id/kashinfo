import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kashinfo/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  bool? isPasswordField;
  final TextInputType? inputType;
  final VoidCallback? onEditingComplete;
  CustomTextField(
      {Key? key,
      required this.hintText,
      required this.icon,
      this.validator,
      this.controller,
      this.isPasswordField = false,
      this.inputType = TextInputType.text,
      this.onEditingComplete})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obsecureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.inputType,
      controller: widget.controller,
      cursorColor: AppColors.pink.withOpacity(0.7),
      style: TextStyle(color: AppColors.pink),
      validator: widget.validator,
      obscureText: widget.isPasswordField! ? obsecureText : false,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: AppColors.pink),
        errorStyle: TextStyle(color: Colors.white),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        hintText: widget.hintText,
        suffixIcon: widget.isPasswordField!
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: IconButton(
                  onPressed: () {
                    obsecureText = !obsecureText;
                    setState(() {});
                  },
                  icon: Icon(
                    obsecureText
                        ? FontAwesomeIcons.lock
                        : FontAwesomeIcons.lockOpen,
                    color: AppColors.pink,
                  ),
                ),
              )
            : null,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(widget.icon, color: AppColors.pink),
        ),
        filled: true,
        fillColor: Colors.white70,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
