import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/screens/init_view/init_view.dart';
import 'package:tripmate/service/firebase_services.dart';

import '../../common/common_popup.dart';
import '../../common/common_widgets.dart';

class ChatRoomViewModel extends ChangeNotifier {
  late DialogFlowtter _dialogFlowtter;
  DialogFlowtter get dialogFlowtter => _dialogFlowtter;

  final TextEditingController _controller = TextEditingController();
  TextEditingController get controller => _controller;

  Stream<QuerySnapshot<MessageModel>>? _chatRef;
  Stream<QuerySnapshot<MessageModel>>? get chatRef => _chatRef;

  bool _isBotTyping = false;
  bool get isBotTyping => _isBotTyping;

  void onInit(BuildContext context) {
    DialogFlowtter.fromFile().then((instance) => _dialogFlowtter = instance);
    _chatRef = FirebaseServices.chatRef;
  }

  void onSentMessage() async {
    final text = _controller.text;
    if (_controller.text != "") {
      FirebaseServices.sentMessage(message: MessageModel(message: text, isSenderMessage: true)).then((value) async {
        _controller.clear();
        _isBotTyping = true;
        notifyListeners();
        DetectIntentResponse response = await dialogFlowtter.detectIntent(queryInput: QueryInput(text: TextInput(text: text)));
        if (response.message != null) {
          debugPrint(response.message?.text?.text?[0].toString());
          FirebaseServices.sentMessage(message: MessageModel(message: response.message?.text?.text?[0], isSenderMessage: false));
          _isBotTyping = false;
          notifyListeners();
        }
      });
    }
  }

  void onLogout(BuildContext context) {
    showCommonPopup(
        context,
        const CommonPopup(
          text: "Logout",
          desc: "Do you want to logout?",
        )).then((value) {
      if (value != null && value) {
        FirebaseAuth.instance.signOut().then((value) {
          Navigator.of(context).popAndPushNamed(InitView.routeName);
        });
      }
    });
  }
}
