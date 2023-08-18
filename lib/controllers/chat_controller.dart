import 'dart:async';
import 'package:flutter_chat_app/model/message.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_app/data_provider/messages_remote.dart';
import 'auth_controller.dart';

class ChatController extends GetxController with StateMixin {
  final MessageRemoteDataProvider messageRemoteDataProvider;

  StreamSubscription? _subscription;
  ChatController({
    required this.messageRemoteDataProvider,
  });
  @override
  void onInit() {
    super.onInit();
    initSubscription();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  initSubscription() {
    change([], status: RxStatus.loading());
    _subscription = messageRemoteDataProvider.listenToMessages().listen((messages) {
      if (messages.isEmpty) {
        change([], status: RxStatus.empty());
        return;
      }
      change(messages, status: RxStatus.success());
    });
  }

  Future<void> sendMessage(String message, [String? replyId]) {
    final myId = Get.find<AuthController>().userId;

    MessageModel messageData;

    if (replyId == null) {
      messageData = MessageModel(
        text: message,
        authorId: myId,
        authorName: myId.substring(0, 5),
        createdAt: DateTime.now(),
      );
    } else {
      messageData = MessageModel(
        text: message,
        authorId: myId,
        authorName: myId.substring(0, 5),
        createdAt: DateTime.now(),
        replyTo: replyId,
      );
    }

    return messageRemoteDataProvider.sendMessage(messageData);
  }
}
