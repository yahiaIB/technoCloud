import 'package:flutter/material.dart';
import 'package:task/model/users_entity.dart';
import 'package:task/screens/chat/chat_screen.dart';
import 'package:task/screens/splash_screen.dart';

class Routes {
  //TODO Define your routes name, init this routes in material App variable 'routes'
  Routes._();

  //static variables
  static const String initRoute = '/';
  static const String chatScreen = '/chat_screen';
  static const String chatsScreen = '/chats_screen';
  static const String createUserScreen = '/create_user_screen';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case chatsScreen:
        return MaterialPageRoute(builder: (_) => Container());
      case createUserScreen:
        return MaterialPageRoute(builder: (_) => Container());
      case chatScreen:
        var data = settings.arguments as User;
        return MaterialPageRoute(builder: (_) => ChatScreen(data));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            )
        );
    }
  }

  static final routes = <String, WidgetBuilder>{
    initRoute: (BuildContext context) => const SplashScreen(),
    chatsScreen: (BuildContext context) => Container()
  };
}
