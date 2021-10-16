import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/styles/custom_assets.dart';
import 'package:task/viewmodels/authentication_model.dart';

import 'chats/chats_screen.dart';
import 'create_user_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationViewModel>(
        builder: (context, authModel, child) =>
            screen(authModel.status, child,context));
  }

  Widget screen(AppStatus appStatus, Widget? child,context) {
    if (appStatus == AppStatus.authenticating) {
      return CreateUserScreen();
    }
    if (appStatus == AppStatus.authenticated) {
      return const ChatsScreen();
    }
    return Scaffold(
      body: Center(
        child: Image.asset(
          CustomAssets.appLogo,
        ),
      ),
    );
  }
}
