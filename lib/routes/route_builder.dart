import 'package:flutter/material.dart';
import 'package:my_day_app/pages/blacklist_page.dart';
import 'package:my_day_app/pages/configure_alert_sound_page.dart';
import 'package:my_day_app/pages/configure_lang_page.dart';
import 'package:my_day_app/pages/goal_remind_page.dart';
import 'package:my_day_app/pages/goals_page.dart';
import 'package:my_day_app/pages/home_page.dart';
import 'package:my_day_app/pages/onboarding_screen.dart';
import 'package:my_day_app/pages/personal_info_page.dart';
import 'package:my_day_app/pages/settings_page.dart';
import 'package:my_day_app/pages/start_page.dart';
import 'package:my_day_app/pages/story_page.dart';

class MyRouteBuilder{
  static Route<dynamic> buildRoute(RouteSettings settings){
    final Map<String,dynamic> args=settings.arguments;

    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_)=>StartPage());
      case '/onboarding':
        print('444');
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
      case '/settings':
        return MaterialPageRoute(builder: (_)=>SettingsPage(database: args['database']));
      case '/configurealertsound':
        return MaterialPageRoute(builder: (_)=>ConfigureAlertSoundPage(database: args['database']));
      case '/configurelang':
        return MaterialPageRoute(builder: (_)=>ConfigureLangPage(database: args['database']));
      case '/personalinfo':
        return MaterialPageRoute(builder: (_)=>PersonalInfoPage(database: args['database']));
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