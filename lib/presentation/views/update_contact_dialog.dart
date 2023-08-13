import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_contact/business_logic/app_cubit.dart';
import 'package:sizer/sizer.dart';

import '../styles/colors.dart';
import '../widgets/default_form_field.dart';
import '../widgets/phone_form_field.dart';

class UpdateContactDialog extends StatefulWidget {
  const UpdateContactDialog({Key? key, required this.contactModel})
      : super(key: key);
  final Map contactModel;

  @override
  State<UpdateContactDialog> createState() => _UpdateContactDialogState();
}

class _UpdateContactDialogState extends State<UpdateContactDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _namedController =
      TextEditingController(text: widget.contactModel['name']);

  late final TextEditingController _phonedController;

  /*extEditingController(
      text: widget.contactModel['phoneNumber'].substring(
          widget.contactModel['codeLength']));*/

  CountryCode myCountryCode = CountryCode(name: 'EG', dialCode: '+20');

  @override
   void initState() {

    _phonedController = TextEditingController(

        text: widget.contactModel['phoneNumber'].substring(
            widget.contactModel['codeLength']));
    super.initState();
  }
  /*void didChangeDependencies() {
    _phonedController = TextEditingController(
        text: widget.contactModel['phoneNumber']
            .substring(widget.contactModel['codeLength']));
    super.didChangeDependencies();
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Dialog(
          backgroundColor: blackHome,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.sp),
          ),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(15.sp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: DefaultFormField(
                      controller: _namedController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "name can't be empty";
                        }
                        return null;
                      },
                      textColor: lightPurple,
                      prefixIcon: const Icon(
                        Icons.title,
                        color: lightPurple,
                      ),
                      hintText: 'Contact Name',
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: lightPurple,
                      )),
                    ),
                  ),
                  BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                      return DefaultPhoneFormField(
                        controller: _phonedController,
                        textColor: lightPurple,
                        labelText: 'Contact phone number',
                        labelColor: Colors.grey,
                        labelSize: 12.sp,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: lightPurple,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Phone number can't be empty";
                          }
                          return null;
                        },
                        onChange: (value) {
                          myCountryCode = value;
                        },
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await AppCubit.get(context).updateContact(
                                codeLength: myCountryCode.dialCode!.length,
                                  id: widget.contactModel['id'],
                                  name: _namedController.text,
                                  phoneNumber:
                                      '${myCountryCode.dialCode}${_phonedController.text}');



                              Fluttertoast.showToast(
                                  msg: "Contact Updated !",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: const Text('Update')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
