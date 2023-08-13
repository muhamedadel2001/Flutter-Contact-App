import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/app_cubit.dart';
import '../../views/contacts_list_builder.dart';
class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late List<Map> favouriteList;

  @override
  void didChangeDependencies() {
    favouriteList = AppCubit
        .get(context)
        .favourites;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return ContactsListsBuilder(
          contacts: favouriteList,
          noContactsText: 'No favourites Added',
          contactType: 'favourite',
        );
      },
    );
  }
}
