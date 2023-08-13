part of 'app_cubit.dart';


abstract class AppState {}

class AppInitial extends AppState {}
class AppChangeBottomNavBarState extends AppState {}
class AppChangeBottomSheetState extends AppState {}
class AppOpenDatabaseState extends AppState {}
class AppLoadingGetContactsState extends AppState {}
class AppDoneGetContactsState extends AppState {}
class AppLoadingGetContactsFavouriteState extends AppState {}
class AppDoneGetContactsFavouriteState extends AppState {}
class AppInsertContactsState extends AppState {}
class AppAddOrRemoveFavouriteState extends AppState {}
class AppUpdateContactState extends AppState {}
class AppDeleteContactState extends AppState {}


