import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../styles/colors.dart';

class DefaultPhoneFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Color? textColor;
  final void Function(CountryCode)? onChange;
  final InputBorder? border;
  final String? hintText;
  final String? labelText;
  final Color? labelColor;
  final double? labelSize;

  final InputBorder?focusedBorder;

  const DefaultPhoneFormField({
    Key? key,
    required this.controller,
    this.validator,
    this.textColor,
    this.onChange,
    this.border = const OutlineInputBorder(borderSide: BorderSide(width: 1),),
    this.hintText = 'Eg. 123456789',
    this.labelText,
    this.labelColor, this.focusedBorder, this.labelSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: TextInputType.phone,
      style: TextStyle(
        color: textColor,
      ),
      decoration: InputDecoration(
        focusedBorder: focusedBorder,
        prefixIcon: CountryCodePicker(
          onChanged: onChange,
          initialSelection: 'IN',
          favorite: const ['+20', 'EG'],
        ),
        isDense: true,
        border: border,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,

        ),
        iconColor: white,
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: labelColor,
          fontSize: labelSize,
        ),
      ),
    );
  }
}