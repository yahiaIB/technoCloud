import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/app/routes.dart';
import 'package:task/viewmodels/authentication_model.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthenticationViewModel>(
      create: (_) => AuthenticationViewModel()..init(),
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Routes.initRoute,
        onGenerateRoute: Routes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
