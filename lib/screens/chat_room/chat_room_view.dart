import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/brand_color.dart';
import '../../common/brand_text.dart';
import '../../common/common_widgets.dart';
import '../../service/firebase_services.dart';
import 'chat_room_view_model.dart';

class ChatRoomView extends StatelessWidget {
  static const routeName = "chat_room_view";

  const ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatRoomViewModel>.nonReactive(
        viewModelBuilder: () => ChatRoomViewModel(),
        onViewModelReady: (model) => model.onInit(context),
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              // leadingWidth: 300.0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Container(
                    height: 45.0,
                    width: 45.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icon.png'),
                      ),
                    ),
                  ),
                  // const CircleAvatar(
                  //   radius: 25.0,
                  //   foregroundImage: AssetImage('assets/icon.png'),
                  //   backgroundColor: Colors.white,
                  // ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/title_logo.png',
                        width: 90.0,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.fiber_manual_record_rounded,
                            color: Colors.green,
                            size: 15.0,
                          ),
                          Text(
                            "Online",
                            style: TextStyle(color: Colors.green, fontSize: 14.0),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              backgroundColor: Colors.white,
              actions: [
                InkWell(
                  onTap: () => model.onLogout(context),
                  child: const Icon(
                    Icons.power_settings_new_rounded,
                    color: Colors.red,
                    size: 32.0,
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                )
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: _ChatList(),
                ),
                _TypingView(),
                _ChatFeild(),
              ],
            ),
            // bottomNavigationBar: _ChatFeild(),
          );
        });
  }
}

class _TypingView extends ViewModelWidget<ChatRoomViewModel> {
  @override
  Widget build(BuildContext context, ChatRoomViewModel viewModel) {
    if (viewModel.isBotTyping) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: _ChatTile(MessageModel(message: "•••••", isSenderMessage: false)),
      );
    }
    return const SizedBox.shrink();
  }
}

class _ChatList extends ViewModelWidget<ChatRoomViewModel> {
  @override
  Widget build(BuildContext context, ChatRoomViewModel viewModel) {
    return StreamBuilder(
        stream: viewModel.chatRef,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Hey what's up..."));
          } else if (snapshot.connectionState == ConnectionState.active) {
            final docs = snapshot.data!.docs;
            return ListView.separated(
                // shrinkWrap: true,
                reverse: true,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  return _ChatTile(docs[index].data());
                },
                separatorBuilder: (_, __) {
                  return const SizedBox(height: 8.0);
                },
                itemCount: docs.length);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class _ChatTile extends ViewModelWidget<ChatRoomViewModel> {
  final MessageModel message;
  const _ChatTile(this.message);
  @override
  Widget build(BuildContext context, ChatRoomViewModel viewModel) {
    bool isSender = message.isSenderMessage ?? false;
    return Padding(
      padding: EdgeInsets.only(left: isSender ? 38.0 : 0.0, right: isSender ? 0.0 : 38.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // if (!isSender) app_.svgImage(svg: bubleNipLeftSvg, height: 8.0, color: colors_.ashDark.withOpacity(0.7)),
                    if (!isSender) ...[
                      const CircleAvatar(
                        radius: 16.0,
                        backgroundImage: AssetImage('assets/icon.png'),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(width: 4.0)
                    ],
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0, bottom: 12.0),
                        decoration: BoxDecoration(
                          // color: isSender ? colors_.brandColor : colors_.ashDark,
                          gradient: isSender
                              ? LinearGradient(
                                  colors: [
                                    BrandColors.brandColor.withOpacity(0.9),
                                    BrandColors.brandColor.withOpacity(0.7),
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors.grey.withOpacity(0.2),
                                    Colors.grey.withOpacity(0.1),
                                  ],
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                ),
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12.0),
                              topRight: const Radius.circular(12.0),
                              bottomLeft: Radius.circular(isSender ? 12.0 : 0.0),
                              bottomRight: Radius.circular(isSender ? 0.0 : 12.0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                message.message ?? "",
                                style: TextStyle(color: isSender ? Colors.white : Colors.black, fontSize: 16.0),
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            if (message.dateTime != null)
                              Text(
                                timeFormat(message.dateTime?.toDate()),
                                style: TextStyle(color: isSender ? Colors.white : Colors.black, fontSize: 12.0),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // if (isSender) app_.svgImage(svg: bubleNipRightSvg, height: 8.0, color: colors_.brandColor.withOpacity(0.75))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatFeild extends ViewModelWidget<ChatRoomViewModel> {
  @override
  Widget build(BuildContext context, ChatRoomViewModel viewModel) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white70,
          border: Border(
              top: BorderSide(
            color: Colors.black12,
            width: 1,
          ))),
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, top: 8.0, right: 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextFormField(
                controller: viewModel.controller,
                maxLines: 3,
                minLines: 1,
                // textAlign: TextAlign.center,
                textInputAction: TextInputAction.done,
                style: BrandTexts.textStyle(fontSize: 15.0, color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Type a Message...",
                  hintStyle: BrandTexts.textStyle(fontSize: 15.0, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  errorMaxLines: 2,
                  contentPadding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 6.0),
                  border: outlineInputBorder(),
                  errorBorder: outlineInputBorder(),
                  enabledBorder: outlineInputBorder(),
                  focusedBorder: outlineInputBorder(),
                  focusedErrorBorder: outlineInputBorder(),
                )),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: const BoxDecoration(
                    // color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mic,
                    size: 28.0,
                    color: BrandColors.brandColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => viewModel.onSentMessage(),
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: const BoxDecoration(
                    // color: colors_.scaffoldBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.send,
                    size: 28.0,
                    color: BrandColors.brandColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  OutlineInputBorder outlineInputBorder() => OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black26),
        gapPadding: 0.0,
        borderRadius: BorderRadius.circular(30.0),
      );
}
