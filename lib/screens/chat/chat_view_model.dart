import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task/model/message_entity.dart';
import 'package:task/model/users_entity.dart';
import 'package:task/repository/chat_repository.dart';
import 'package:task/repository/user_repository.dart';
import 'package:task/viewmodels/base_model.dart';

class ChatViewModel extends BaseViewModel {

  List<MessageEntity> chatMessages = [];
  TextEditingController messageController = TextEditingController();

  // SocketManager _manager = SocketManager.getInstance();
  ScrollController scrollController = ScrollController();
  bool sendingMessage = false;
  ChatRepository chatRepository = ChatRepository();
  UserRepository userRepository = UserRepository();
  String? _chatId;
  User? _user;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? messagesRefListener;

  initChat(friendId) async {
    setBusyWithOutNotify(true);
    try{
      _user = userRepository.getUserLocal();
      _chatId = await chatRepository.getChatId([friendId,_user!.id]);
      // chatMessages = await chatRepository.getMessages(_chatId);
      listenToNewMessages();
      setBusy(false);
    }catch(e){
      print(e);
    }

  }

  selectImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(file != null){
      createMessage(image: file);
    }
  }

  createMessage({XFile? image}) async {
    String? text;
    if(messageController.text.trim().isNotEmpty) text = messageController.text.trim();
    else if(image == null) return;
    var message = await chatRepository.createMessage(_chatId,_user!.id,image: image,text: text);
    messageController.text = "";
    notifyListeners();
  }

  listenToNewMessages() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    messagesRefListener = await db.collection('chats').doc("$_chatId").collection("messages").orderBy("timestamp").snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          onReceiveMessage(data);
        }
      });
    });
  }

  onReceiveMessage(data){
    chatMessages.add(MessageEntity().fromJson(data));
    controllerAnimateToLast();
    notifyListeners();
  }

  controllerAnimateToLast(){
    if(scrollController.hasClients){
      scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messagesRefListener?.cancel();
  }

}