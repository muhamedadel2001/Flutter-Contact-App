import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_contact/presentation/screens/contacts/contacts_screen.dart';
import 'package:simple_contact/presentation/screens/favourites/favourites_screen.dart';
import 'package:sqflite/sqflite.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);
  int currentIndex = 0;
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
  bool isBottomSheetShown = false;
  IconData floatingActionButton = Icons.person_add;
  //late Database database;
  List<Widget> screens = [
    const ContactScreen(),
    const FavouritesScreen(),
  ];
  List<String> texts = ['Contacts', 'Favourites'];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void changeBottomSheetState({required bool isShown, required IconData icon}) {
    isBottomSheetShown = isShown;
    floatingActionButton = icon;
    emit(AppChangeBottomSheetState());
  }

  List<Map> contacts = [];
  List<Map> favourites = [];

  void createDatabase() {
    /* openDatabase(
        'contacts.db', version: 1, onCreate: (db, version) {
      if (kDebugMode) {
        print('Database created!');
      }
      db
          .execute(
              'CREATE TABLE contacts(id INTEGER PRIMARY KEY,name TEXT,phoneNumber TEXT,type TEXT,codeLength INTEGER )')
          .then((value) {
        if (kDebugMode) {
          print('table created');
        }
      }).catchError((error) {
        if (kDebugMode) {
          print('error happened while created$error');
        }
      });
    }, onOpen: (db) {
      getContacts(db);
      if (kDebugMode) {
        print('database opened');
      }
    }).then((value) {
      database = value;
      emit(AppOpenDatabaseState());
    });*/
getContacts();
getContactsFavourite();
  }

  void getContacts(/*Database database*/) async {
    emit(AppLoadingGetContactsState());
    /* contacts.clear();
    favourites.clear();*/

    /*await database.rawQuery('SELECT* FROM contacts ').then((value) {
      for (Map<String, Object?> element in value) {
        contacts.add(element);
        if (element['type'] == 'favourite') {
          favourites.add(element);
        }
      }
    });
    emit(AppDoneGetContactsState());*/
    await fireStore.collection('contacts').get().then((value) {
      contacts.clear();
      for (QueryDocumentSnapshot<Map<String, dynamic>> element in value.docs) {
        contacts.add(element.data());
      }
      emit(AppDoneGetContactsState());
    });
  }

  void getContactsFavourite(/*Database database*/) async {
    emit(AppLoadingGetContactsFavouriteState());

    await fireStore
        .collection('contacts')
        .where('type', isEqualTo: 'favourite')
        .get()
        .then((value) {
      favourites.clear();
      for (QueryDocumentSnapshot<Map<String, dynamic>> element in value.docs) {
        favourites.add(element.data());
      }
      emit(AppDoneGetContactsFavouriteState());
    });
  }

  insertToAccount(
      {required String name,
      required String phoneNumber,
      required int codeLength}) async {
    /* await database.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO contacts(name,phoneNumber,type,codeLength)VALUES("$name","$phoneNumber","all","$codeLength")');
    }).then((value) {
      if (kDebugMode) {
        print('contact$value success inserted');
      }
      emit(AppInsertContactsState());
      getContacts(database);
    }).catchError((error) {
      if (kDebugMode) {
        print('error while insert $error');
      }
    });*/
    int uniqId = DateTime.now().millisecondsSinceEpoch;
    await fireStore.collection('contacts').doc(uniqId.toString()).set({
      'id': uniqId,
      'name': name,
      'phoneNumber': phoneNumber,
      'codeLength': codeLength,
      'type': 'all'
    }).then((value) {
      emit(AppInsertContactsState());
      getContacts();
      getContactsFavourite();
    });
  }

  void addOrRemoveFavourite({required String type, required int id}) async {
    /*await database.rawUpdate(
        'UPDATE contacts SET type =?WHERE id =?', [type, id]).then((value) {
      getContacts(database);
      emit(AppAddOrRemoveFavouriteState());
    });*/
    await fireStore
        .collection('contacts')
        .doc(id.toString())
        .update({'type': type}).then((value) {
      emit(AppAddOrRemoveFavouriteState());
      getContacts();
      getContactsFavourite();
    });
  }

  Future<void> updateContact(
      {required String name,
      required String phoneNumber,
      required int codeLength,
      required int id}) async {
    /*await database.rawUpdate(
        'UPDATE contacts SET name =?, phoneNumber =?,codeLength =?WHERE id =?',
        [name, phoneNumber, codeLength, id]).then((value) {
      getContacts(database);
      emit(AppUpdateContactState());
    });*/
    await fireStore.collection('contacts').doc(id.toString()).update({
      'name': name,
      'phoneNumber': phoneNumber,
      'codeLength': codeLength
    }).then((value) {
      emit(AppUpdateContactState());
      getContacts();
      getContactsFavourite();
    });
  }

  Future<void> deleteContact({required int id}) async {
    /* await database
        .rawDelete('DELETE FROM contacts WHERE id=?', [id]).then((value) {
      getContacts(database);
      emit(AppDeleteContactState());
    });*/
    await fireStore
        .collection('contacts')
        .doc(id.toString())
        .delete()
        .then((value) {
      emit(AppDeleteContactState());
      getContacts();
      getContactsFavourite();
    });
  }
}
