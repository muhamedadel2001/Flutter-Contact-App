import 'package:flutter/material.dart';
import 'package:simple_contact/core/constants.dart'as screens;
import 'package:simple_contact/presentation/screens/home/home_layout.dart';
import 'package:simple_contact/presentation/screens/splash/Splash_screen.dart';

class AppRouter{
  late Widget startScreen;
  Route? onGenerateRoute(RouteSettings settings){
    startScreen=const SplashScreen();
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_)=>startScreen);
      case screens.homeLayout:
        return MaterialPageRoute(builder: (_)=>const HomeLayout());

      default:
        return null;
    }

  }
}