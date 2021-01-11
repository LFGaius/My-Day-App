import 'package:flutter/material.dart';
import 'package:my_day_app/pages/home_page.dart';
import 'package:my_day_app/pages/onboarding_screen.dart';
import 'package:my_day_app/pages/start_page.dart';

class MyRouteBuilder{
  static Route<dynamic> buildRoute(RouteSettings settings){
    final Map<String,dynamic> args=settings.arguments;

    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_)=>StartPage());
      case '/onboarding':
        return MaterialPageRoute(builder: (_)=>OnboardingScreen(database: args['database']));
      case '/home':
        return MaterialPageRoute(builder: (_)=>HomePage(database: args['database'],));
      default: return errorRoute();
    }
  }

  static Route<dynamic> errorRoute(){
    return MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('ERROR'),
            ),
          );
        }
    );
  }
}