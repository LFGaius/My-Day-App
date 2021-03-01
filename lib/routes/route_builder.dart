import 'package:flutter/material.dart';
import 'package:my_day_app/pages/blacklist_page.dart';
import 'package:my_day_app/pages/goal_remind_page.dart';
import 'package:my_day_app/pages/goals_page.dart';
import 'package:my_day_app/pages/home_page.dart';
import 'package:my_day_app/pages/onboarding_screen.dart';
import 'package:my_day_app/pages/start_page.dart';
import 'package:my_day_app/pages/story_page.dart';

class MyRouteBuilder{
  static Route<dynamic> buildRoute(RouteSettings settings){
    final Map<String,dynamic> args=settings.arguments;

    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_)=>StartPage());
      case '/onboarding':
        return MaterialPageRoute(builder: (_)=>OnboardingScreen(database: args['database']));
      case '/goals':
        return MaterialPageRoute(builder: (_)=>GoalsPage(database: args['database']));//args['database']
      case '/story':
        return MaterialPageRoute(builder: (_)=>StoryPage(database: args['database'],date: args['date'],));
      case '/blacklist':
        return MaterialPageRoute(builder: (_)=>BlacklistPage(database: args['database']));
      case '/goalremind':
        return MaterialPageRoute(builder: (_)=>GoalRemindPage(database: args['database']));
      case '/home':
        return MaterialPageRoute(builder: (_)=>HomePage(database: args['database'],startTab:args['startTab'] ,));
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