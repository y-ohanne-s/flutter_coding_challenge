import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/chat_controller.dart';
import 'package:flutter_chat_app/model/message.dart';
import 'package:get/get.dart';

class MessageComposer extends StatefulWidget {
  const MessageComposer({
    super.key,
    required this.focusNode,
    this.replyMessage,
    this.onReplyCancel,
  });

  final FocusNode focusNode;
  final (MessageModel?, String?)? replyMessage;
  final VoidCallback? onReplyCancel;
  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final TextEditingController _textEditingController = TextEditingController();

  ChatController get chatController => Get.find();
  bool isComposingMessage = false;

  replyWidget() {
    return Container(
      color: Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(
        children: [
          const Icon(Icons.reply, color: Colors.indigo),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.replyMessage!.$1 == null ? '' : widget.replyMessage!.$1!.authorName,
                    style: TextStyle(color: Colors.indigo.shade300),
                  ),
                  Text(
                    widget.replyMessage!.$1 == null ? '' : widget.replyMessage!.$1!.text,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onReplyCancel,
            child: const Icon(Icons.close, color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.replyMessage != null && widget.replyMessage!.$1 != null) replyWidget(),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16.0),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              const SizedBox(width: 18.0),
              Expanded(
                child: TextField(
                  focusNode: widget.focusNode,
                  controller: _textEditingController,
                  onChanged: (value) {
                    setState(() {
                      isComposingMessage = value.isNotEmpty;
                    });
                  },
                  decoration: const InputDecoration.collapsed(
                    hintText: "Send a message",
                  ),
                ),
              ),
              IconButton(
                onPressed: isComposingMessage
                    ? () {
                        widget.focusNode.unfocus();
                        widget.onReplyCancel!();

                        chatController.sendMessage(
                          _textEditingController.text,
                          widget.replyMessage != null ? widget.replyMessage!.$2 : null,
                        );
                        _textEditingController.clear();
                        setState(() {
                          isComposingMessage = false;
                        });
                      }
                    : null,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
