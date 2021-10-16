import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/model/message_entity.dart';
import 'package:task/model/users_entity.dart';
import 'package:task/utils/helper_functions.dart';
import '../image_viewer_screen.dart';
import 'chat_view_model.dart';

class ChatScreen extends StatelessWidget {
  final User user;

  ChatScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel()..initChat(user.id),
      child: Consumer<ChatViewModel>(
        builder: (context, chatViwModel, _) => chatViwModel.busy
            ? Container(
          color: Colors.white,
              child: const Center(
                  child: CircularProgressIndicator(),
                ),
            )
            : Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.grey[400],
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            image: DecorationImage(
                                image: NetworkImage(user.image!),
                                fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("${user.name}",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    chatViwModel.chatMessages.length == 0
                        ? Container()
                        : SingleChildScrollView(
                            controller: chatViwModel.scrollController,
                            reverse: true,
                            padding: const EdgeInsets.only(
                                right: 16, left: 16, bottom: 80),
                            child: Column(
                              children: _renderMessages(
                                  chatViwModel.chatMessages, context),
                            ),
                          ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          height: 70,
                          child: Scrollbar(
                            isAlwaysShown: true,
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: TextField(
                                controller: chatViwModel.messageController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent)),
                                  contentPadding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  hintText: "Type your message",
                                  fillColor: Colors.black12,
                                  filled: true,
                                  prefixIcon: IconButton(
                                    splashColor: Colors.white,
                                    icon: const Icon(
                                      Icons.attach_file,
                                      color: Colors.blue,
                                    ),
                                    iconSize: 22,
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      chatViwModel.selectImage();
                                    },
                                  ),
                                  suffixIcon: chatViwModel.sendingMessage
                                      ? const Icon(
                                          Icons.send,
                                          color: Colors.black45,
                                          size: 28,
                                        )
                                      : IconButton(
                                          icon: const Icon(
                                            Icons.send,
                                            color: Colors.blueAccent,
                                            size: 28,
                                          ),
                                          padding: EdgeInsets.all(0),
                                          onPressed: () async {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            await chatViwModel.createMessage();
                                          }),
                                ),
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
      ),
    );
  }

  List<Widget> _renderMessages(List<MessageEntity> messages, context) {
    List<Widget> widgets = [];
    var last_message = messages[0].sendBy;
    widgets.add(applyMessage(messages[0], "", context));
    for (int i = 1; i < messages.length; i++) {
      widgets.add(applyMessage(messages[i], last_message, context));
      last_message = messages[i].sendBy;
    }
    return widgets;
  }

  applyMessage(MessageEntity message, lastMessage, context) {
    if (message.sendBy == HelperFunctions.getUserId()) {
      return myMessage(message, context, image: lastMessage != message.sendBy);
    } else {
      return otherMessage(message, context,
          image: lastMessage != message.sendBy);
    }
  }

  Widget myMessage(MessageEntity message, context, {bool? image}) {
    BorderRadius radius = BorderRadius.only(
      bottomRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      topLeft: Radius.circular(16),
      topRight: Radius.circular(0),
    );
    return Container(
      margin: EdgeInsets.only(top: image! ? 20 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          message.image == null
              ? Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .7,
                  ),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00A3FE),
                          Color(0xFF0092FE),
                          Color(0xFF00A3FE),
                        ],
                      ),
                      borderRadius: radius),
                  child: SelectableText(
                    message.text!,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : _renderImage(context, message.image, radius),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Widget otherMessage(MessageEntity message, context, {bool? image}) {
    BorderRadius radius = const BorderRadius.only(
      bottomRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      topLeft: Radius.circular(0),
    );
    var userImage = user.image;
    return Container(
      margin: EdgeInsets.only(top: image! ? 20 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image
              ? Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                        image: NetworkImage(userImage!), fit: BoxFit.cover),
                  ),
                )
              : const SizedBox(
                  width: 30,
                ),
          const SizedBox(
            width: 8,
          ),
          message.image == null
              ? Container(
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .7,
                  ),
                  decoration:
                      BoxDecoration(color: Colors.grey[300], borderRadius: radius),
                  child: SelectableText(
                    message.text!,
                    style: TextStyle(color: Colors.black),
                  ),
                )
              : _renderImage(context, message.image, radius)
        ],
      ),
    );
  }

  Widget _renderImage(context, url, BorderRadius radius) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HeroPhotoViewWrapper(
              imageProvider: NetworkImage(url),
            ),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .7,
          maxHeight: 300,
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Image.network(url),
        ),
      ),
    );
  }
}
