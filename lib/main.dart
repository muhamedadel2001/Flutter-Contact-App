import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_contact/business_logic/app_cubit.dart';
import 'package:simple_contact/presentation/router/app_router.dart';
import 'package:sizer/sizer.dart';

import 'core/my_bloc_observers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return BlocProvider(
          create: (context) => AppCubit()..createDatabase(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Simple Contacts',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            onGenerateRoute: appRouter.onGenerateRoute,
          ),
        );
      },
    );
  }
}
