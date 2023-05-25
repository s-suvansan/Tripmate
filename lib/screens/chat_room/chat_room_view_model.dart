import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/screens/init_view/init_view.dart';
import 'package:tripmate/service/firebase_services.dart';

import '../../common/common_popup.dart';
import '../../common/common_widgets.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatRoomViewModel extends ChangeNotifier {
  late DialogFlowtter _dialogFlowtter;
  DialogFlowtter get dialogFlowtter => _dialogFlowtter;

  final TextEditingController _controller = TextEditingController();
  TextEditingController get controller => _controller;

  Stream<QuerySnapshot<MessageModel>>? _chatRef;
  Stream<QuerySnapshot<MessageModel>>? get chatRef => _chatRef;

  bool _isBotTyping = false;
  bool get isBotTyping => _isBotTyping;

  bool _isListening = false;
  bool get isListening => _isListening;

  late stt.SpeechToText speech;

  void onInit(BuildContext context) {
    speech = stt.SpeechToText();
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
          _chatRef = null;
          Navigator.of(context).popAndPushNamed(InitView.routeName);
        });
      }
    });
  }

  void onSpeech() async {
    if (!_isListening) {
      _isListening = true;
      notifyListeners();
      bool available = await speech.initialize(onStatus: (_) {}, onError: (_) {}, debugLogging: true);
      if (available) {
        speech.listen(onResult: (result) {
          debugPrint(result.recognizedWords);
          if (result.recognizedWords != "") {
            _controller.text = result.recognizedWords;
          }
        });
      } else {
        debugPrint("The user has denied the use of speech recognition.");
      }
    } else {
      if (_isListening && _controller.text != "") {
        onSentMessage();
      }
      _isListening = false;
      notifyListeners();
      speech.stop();
    }
  }

  void onStopSpeech() {
    speech.stop();
  }
}
