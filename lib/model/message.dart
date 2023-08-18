import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String text;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final String? replyTo;

  MessageModel({
    required this.text,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.replyTo,
  });

  MessageModel copyWith({
    String? text,
    String? authorId,
    String? authorName,
    DateTime? createdAt,
    final String? replyTo,
  }) {
    return MessageModel(
      text: text ?? this.text,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      replyTo: replyTo ?? this.replyTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': createdAt,
      'replyTo': replyTo,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      text: map['text'] as String,
      authorId: map['authorId'] as String,
      authorName: map['authorName'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      replyTo: map['replyTo'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(text: $text, authorId: $authorId, authorName: $authorName, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.authorId == authorId &&
        other.authorName == authorName &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return text.hashCode ^ authorId.hashCode ^ authorName.hashCode ^ createdAt.hashCode;
  }
}
