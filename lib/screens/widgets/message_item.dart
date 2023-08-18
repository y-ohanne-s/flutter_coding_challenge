import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/model/message.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class MessageItem extends StatelessWidget {
  final MessageModel message;
  const MessageItem({super.key, required this.message});
  bool get isMyMessage => message.authorId == Get.find<AuthController>().userId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMyMessage) ...[
            Padding(
              padding: const EdgeInsets.only(
                left: 6.0,
              ),
              child: Text(
                message.authorName,
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
          Row(
            mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  color: isMyMessage ? Colors.indigo : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.replyTo != null)
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('messages')
                            .doc(message.replyTo)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            MessageModel msg =
                                MessageModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

                            return Row(
                              children: [
                                Container(
                                  color: Colors.white,
                                  height: 25,
                                  width: 3,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          msg.authorName,
                                          style: const TextStyle(color: Colors.white),
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          msg.text,
                                          style: const TextStyle(color: Colors.white),
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    Text(
                      message.text,
                      style: TextStyle(
                        color: isMyMessage ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
