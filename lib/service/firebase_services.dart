import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  static const String _home = "Chats";
  static const String _dateTime = "dateTime";

  static final _auth = FirebaseAuth.instance;
  static final chatRef = FirebaseFirestore.instance
      .collection(_auth.currentUser?.uid ?? _home)
      .orderBy(_dateTime, descending: true)
      .withConverter<MessageModel>(
        fromFirestore: (snapshot, options) {
          return MessageModel.fromJson(snapshot.data());
        },
        toFirestore: (value, options) => value.toJson(),
      )
      .snapshots();

  static Future<bool> sentMessage({required MessageModel message}) async {
    try {
      await FirebaseFirestore.instance
          .collection(_auth.currentUser?.uid ?? _home)
          .doc()
          .set(message.toJson(), SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }
}

class MessageModel {
  String? message;
  bool? isSenderMessage;
  Timestamp? dateTime;

  MessageModel({
    this.message,
    this.isSenderMessage,
    this.dateTime,
  });

  factory MessageModel.fromJson(Map<String, dynamic>? json) => MessageModel(
        message: json?["message"] ?? "",
        isSenderMessage: json?["isSenderMessage"] ?? false,
        dateTime: json?["dateTime"] ?? Timestamp.now(),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "isSenderMessage": isSenderMessage ?? false,
        "dateTime": Timestamp.now(),
      };
}
