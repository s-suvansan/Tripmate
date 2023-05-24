import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tripmate/common/common_widgets.dart';
import 'package:tripmate/common/validator.dart';
import 'package:tripmate/screens/chat_room/chat_room_view.dart';

class InitViewModel extends ChangeNotifier {
  TextEditingController controller = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String? mobileNumberError;
  String? otpVerificationId;
  bool isShowOtpView = false;

  void onContinue(BuildContext context) async {
    mobileNumberError = Validator.validateMobile(controller.text);
    if (mobileNumberError != null) {
      notifyListeners();
      return;
    }
    showRestrictPopLoading(context);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+94${controller.text}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        shopRestrictPopLoading(context);
        showToast(msg: e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVerificationId = verificationId;
        isShowOtpView = true;
        notifyListeners();
        shopRestrictPopLoading(context);
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // shopRestrictPopLoading(context);
        // showToast(msg: "Seems like time out.");
      },
    );
    notifyListeners();
  }

  void onBackToPhnNumberView(BuildContext context) {
    isShowOtpView = false;
    notifyListeners();
  }

  void onVerifyOtp(BuildContext context, String pin) async {
    showRestrictPopLoading(context);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: otpVerificationId!, smsCode: pin);
    FirebaseAuth.instance.signInWithCredential(credential).then((userCredential) {
      if (userCredential.user != null) {
        shopRestrictPopLoading(context);
        Future.delayed(const Duration(milliseconds: 200), () {
          Navigator.popAndPushNamed(context, ChatRoomView.routeName);
        });
      } else {
        shopRestrictPopLoading(context);
        showToast(msg: "Seems like invalid OTP.");
      }
    });
  }

  void onAnonymousLogin(BuildContext context) {
    showRestrictPopLoading(context);
    FirebaseAuth.instance.signInAnonymously().then((userCredential) {
      if (userCredential.user != null) {
        shopRestrictPopLoading(context);
        Future.delayed(const Duration(milliseconds: 200), () {
          Navigator.popAndPushNamed(context, ChatRoomView.routeName);
        });
      } else {
        shopRestrictPopLoading(context);
        showToast(msg: "Seems like invalid OTP.");
      }
    });
  }
}
