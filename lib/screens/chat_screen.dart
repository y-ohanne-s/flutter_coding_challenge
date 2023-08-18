import 'package:flutter/material.dart';
import 'package:flutter_chat_app/model/message.dart';
import 'package:flutter_chat_app/screens/widgets/message_item.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';
import '../controllers/chat_controller.dart';
import 'widgets/message_composer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatController get chatController => Get.find();
  final focusNode = FocusNode();

  MessageModel? repliedMessage;
  String? repliedToId;

  onMessageSwiped(MessageModel message, String id) {
    setState(() {
      repliedMessage = message;
      repliedToId = id;
    });
  }

  onReplyCancel() {
    setState(() => repliedMessage = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat App",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Expanded(
            child: chatController.obx(
              (state) => ListView.builder(
                itemCount: state.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final value = state[index];
                  final message = value.$1;
                  final id = value.$2;

                  return SwipeTo(
                    onLeftSwipe: () {
                      onMessageSwiped(message, id);
                      focusNode.requestFocus();
                    },
                    leftSwipeWidget: Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 8.0,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(child: Icon(Icons.reply, color: Colors.white)),
                    ),
                    child: MessageItem(message: message),
                  );
                },
              ),
              onEmpty: const Center(
                child: Text("No messages found"),
              ),
              onError: (error) => Center(
                child: Text("Error: $error"),
              ),
              onLoading: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          MessageComposer(
            focusNode: focusNode,
            onReplyCancel: onReplyCancel,
            replyMessage: (repliedMessage, repliedToId),
          )
        ],
      ),
    );
  }
}
