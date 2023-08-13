import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_contact/business_logic/app_cubit.dart';

import '../../views/contacts_list_builder.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late List<Map> contactsList;

  @override
  void didChangeDependencies() {
    contactsList = AppCubit
        .get(context)
        .contacts;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return ContactsListsBuilder(
          contacts: contactsList,
          noContactsText: 'No Contacts Added',
          contactType: 'all',
        );
      },
    );
  }
}
