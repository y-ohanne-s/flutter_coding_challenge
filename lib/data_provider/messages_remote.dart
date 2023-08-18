import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/model/message.dart';

class MessageRemoteDataProvider {
  CollectionReference messagesCollection = FirebaseFirestore.instance.collection('messages');

  Stream<List<(MessageModel, String)>> listenToMessages() {
    return messagesCollection.orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return (MessageModel.fromMap(doc.data() as Map<String, dynamic>), doc.id);
      }).toList();
    });
  }

  Future<void> sendMessage(MessageModel messageData) {
    return messagesCollection.add(messageData.toMap());
  }
}
