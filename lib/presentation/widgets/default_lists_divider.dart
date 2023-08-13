import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DefaultListsDivider extends StatelessWidget {
  const DefaultListsDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children:  [
        Expanded(child: Divider(
          height: 1.h,
          color: Colors.transparent,
        )),
      ],
    );
  }
}
