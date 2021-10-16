import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task/model/message_entity.dart';
import 'package:task/model/users_entity.dart';
import 'package:task/utils/helper_functions.dart';
import 'package:task/utils/preference_utils.dart';

class ChatRepository {
  Future<List<MessageEntity>> getMessages(chatId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    try{
      var messagesRef = await db.collection('chats').doc("$chatId").collection("messages").orderBy("timestamp").get();
      if(messagesRef.docs.length == 0){
        return [];
      }else{
        return messagesRef.docs.map<MessageEntity>((e) => MessageEntity().fromJson(e.data())).toList();
      }
    }catch(e){
      rethrow;
    }
  }

  getChatId(List listOfUsersIds) async {
    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      var chatRef = await db.collection('chats').where("users", isEqualTo: listOfUsersIds).get();
      var chatRefReversed = await db.collection('chats').where("users", isEqualTo: listOfUsersIds.reversed.toList()).get();
      if(chatRef.docs.isEmpty && chatRefReversed.docs.isEmpty){
        return createChat(listOfUsersIds);
      }
      if(chatRef.docs.isEmpty){
        return chatRefReversed.docs.first.id;
      }
      return chatRef.docs.first.id;
    }catch(e){
      rethrow;
    }
  }

  createChat(List listOfUsersIds) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var chatId = HelperFunctions.createUniqueUserId();
    var chatRef = await db.collection('chats').doc(chatId);
    var data= {
      "users": listOfUsersIds,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };
    await chatRef.set(data);
    return chatRef.id;
  }

  createMessage(chatId,userId,{String? text,XFile? image}) async {
    var data = {
      "send_by":userId,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };
    if(image != null){
      print(image.path);
      data["image"] =  await HelperFunctions.saveImage(File(image.path));
    }
    if(text != null){
      data["text"] =  text;
    }
    FirebaseFirestore db = FirebaseFirestore.instance;
    var messagesRef = await db.collection('chats').doc("$chatId").collection("messages");
    var res = await messagesRef.add(data);
    return data;
  }

}
