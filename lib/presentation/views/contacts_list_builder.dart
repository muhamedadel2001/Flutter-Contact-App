import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../widgets/default_lists_divider.dart';
import 'contact_item.dart';

class ContactsListsBuilder extends StatelessWidget {
  final List<Map> contacts;
  final String noContactsText;
  final String contactType;

  const ContactsListsBuilder({Key? key,
    required this.contacts,
    required this.noContactsText,
    required this.contactType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: contacts.isNotEmpty,
      replacement: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_accounts,
              size: 70.sp,
              color: Colors.white,
            ),
            Text(
              noContactsText,
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 2.h),
          child: ListView.separated(
              itemBuilder: (context, index) =>
                  ContactItem(
                    contactModel: contacts[index],
                  ),
              separatorBuilder: (context, index) => const DefaultListsDivider(),
              itemCount: contacts.length),
        ),
    );
  }
}
