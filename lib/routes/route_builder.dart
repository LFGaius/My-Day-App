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
        return MaterialPageRoute(builder: (_)=>OnboardingScreen());
      case '/home':
        return MaterialPageRoute(builder: (_)=>HomePage());
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