import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripmate/screens/chat_room/chat_room_view.dart';
import 'package:tripmate/screens/init_view/init_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FirebaseAuth auth = FirebaseAuth.instance;

  runApp(MyApp(auth: auth));
}

class MyApp extends StatelessWidget {
  final FirebaseAuth? auth;
  const MyApp({super.key, required this.auth});

  // This widget is the root of your application.ks
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      routes: routes_,
      home: auth?.currentUser != null ? const ChatRoomView() : const InitView(),
    );
  }
}

Map<String, Widget Function(BuildContext)> routes_ = <String, WidgetBuilder>{
  ChatRoomView.routeName: ((context) => const ChatRoomView()),
  InitView.routeName: ((context) => const InitView()),
};
