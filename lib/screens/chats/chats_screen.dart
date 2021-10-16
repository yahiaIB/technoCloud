import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/app/routes.dart';
import 'package:task/model/users_entity.dart';
import 'package:task/utils/helper_functions.dart';

import 'chats_view_model.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatsViewModel>(
      create: (_) => ChatsViewModel()..getUsers(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chat with other Users"),
        ),
        body: Consumer<ChatsViewModel>(builder: (context, chatsViewModel, _) {
          return chatsViewModel.busy
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: chatsViewModel.users!.length,
                  padding: const EdgeInsets.all(15),
                  itemBuilder: (context, index) =>_buildUserWidget(chatsViewModel.users![index],context),
                );
        }),
      ),
    );
  }

  _buildUserWidget(User user , context){
    return user.id == HelperFunctions.getUserId() ? Container()  :
    GestureDetector(
      onTap: () => Navigator.pushNamed(context, Routes.chatScreen,arguments: user),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .16,
              height: MediaQuery.of(context).size.width * .16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(user.image!),
                  fit: BoxFit.cover
                )
              ),
            ),
            const SizedBox(width: 10,),
            Text(user.name!,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),)
          ],
        ),
      ),
    );
  }

}
