import 'package:app/model/qb_message_wrapper.dart';
import 'package:app/model/resource.dart';
import 'package:app/utils/stream_builder/app_stream_builder.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:statemanagement_riverpod/statemanagement_riverpod.dart';

import '../../ui_molecules/cards/OwnMessgaeCrad.dart';
import '../../ui_molecules/cards/ReplyCard.dart';
import 'chat_view_model.dart';

class ChatDetailView extends BasePageViewWidget<ChatDetailViewModel> {
  ChatDetailView(ProviderBase<ChatDetailViewModel> model) : super(model);

  @override
  Widget build(BuildContext context, model) {
    final List<QBMessageWrapper> messages = [];
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Image.asset(
          "assets/whatsapp_Back.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              leadingWidth: 70,
              titleSpacing: 0,
              backgroundColor: Colors.teal,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.white,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blueGrey,
                      child: SvgPicture.asset(
                        // widget.chatModel.isGroup
                        //     ? "assets/groups.svg"
                        //     :
                        "assets/person.svg",
                        color: Colors.white,
                        height: 36,
                        width: 36,
                      ),
                    ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.args.name, // widget.chatModel.name,
                        style: const TextStyle(
                            fontSize: 18.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Text(
                        "last seen unknown",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                    icon: const Icon(
                      Icons.videocam,
                      color: Colors.white,
                    ),
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    onPressed: () {}),
                PopupMenuButton<String>(
                  padding: const EdgeInsets.all(0),
                  color: Colors.teal,
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onSelected: (value) {
                    print(value);
                  },
                  itemBuilder: (BuildContext contesxt) {
                    return [
                      const PopupMenuItem(
                        value: "View Contact",
                        child: Text(
                          "View Contact",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem(
                        value: "Media, links, and docs",
                        child: Text("Media, links, and docs",
                            style: TextStyle(color: Colors.white)),
                      ),
                      const PopupMenuItem(
                        value: "Whatsapp Web",
                        child: Text("Whatsapp Web",
                            style: TextStyle(color: Colors.white)),
                      ),
                      const PopupMenuItem(
                        value: "Search",
                        child: Text("Search",
                            style: TextStyle(color: Colors.white)),
                      ),
                      const PopupMenuItem(
                        value: "Mute Notification",
                        child: Text("Mute Notification",
                            style: TextStyle(color: Colors.white)),
                      ),
                      const PopupMenuItem(
                        value: "Wallpaper",
                        child: Text("Wallpaper",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: AppStreamBuilder<Resource<List<QBMessageWrapper>>>(
                    stream: model.messageStream,
                    initialData: Resource.none(),
                    dataBuilder: (context, data) {
                      if (data?.status == Status.success) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data?.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final itemData = data!.data![index];
                            if (itemData.isIncoming) {
                              return OwnMessageCard(
                                message: itemData.qbMessage.body ?? "",
                                time: DateTime.fromMicrosecondsSinceEpoch(
                                        itemData.qbMessage.dateSent ?? 0)
                                    .toString(),
                              );
                            } else {
                              return ReplyCard(
                                message: itemData.qbMessage.body ?? "",
                                time: DateTime.fromMicrosecondsSinceEpoch(
                                        itemData.qbMessage.dateSent ?? 0)
                                    .toString(),
                              );
                            }
                          },
                        );
                      }

                      return const Center(
                        child: Text("No Messages found"),
                      );
                    },
                  ),
                ),
                // Expanded(
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     // controller: _scrollController,
                //     itemCount: messages.length + 1,
                //     itemBuilder: (context, index) {
                //       if (index == messages.length) {
                //         return Container(
                //           height: 70,
                //         );
                //       }
                //       return const Text("msg");
                //       // if (messages[index].type == "source") {
                //       //   return OwnMessageCard(
                //       //     message: messages[index].message,
                //       //     time: messages[index].time,
                //       //   );
                //       // } else {
                //       //   return ReplyCard(
                //       //     message: messages[index].message,
                //       //     time: messages[index].time,
                //       //   );
                //       // }
                //     },
                //   ),
                // ),

                AppStreamBuilder<bool>(
                  stream: model.toggleEmojiKeyboard.stream,
                  initialData: false,
                  dataBuilder: (context, isImojiOpen) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Card(
                                  margin: const EdgeInsets.only(
                                      left: 2, right: 2, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: TextFormField(
                                    controller: model.messageController,
                                    focusNode: model.focusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    onTap: () {
                                      if (isImojiOpen == true) {
                                        model.focusNode.unfocus();
                                      }
                                    },
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Type a message",
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      prefixIcon: IconButton(
                                        // ignore: prefer_const_constructors
                                        icon: Icon(
                                          1 != 1
                                              ? Icons.keyboard
                                              : Icons.emoji_emotions_outlined,
                                        ),
                                        onPressed: () {
                                          model.toggleEmojiKeyboard.add(
                                              !model.toggleEmojiKeyboard.value);
                                        },
                                      ),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.attach_file),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (builder) =>
                                                      bottomSheet(context));
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.camera_alt),
                                            onPressed: () {
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (builder) =>
                                              //             CameraApp()));
                                            },
                                          ),
                                        ],
                                      ),
                                      contentPadding: const EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  right: 2,
                                  left: 2,
                                ),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: const Color(0xFF128C7E),
                                  child: IconButton(
                                    icon: const Icon(
                                      1 == 1 ? Icons.send : Icons.mic,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      model.sendMessage();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                AppStreamBuilder<bool>(
                    stream: model.toggleEmojiKeyboard.stream,
                    initialData: false,
                    dataBuilder: (context, isImojiOpen) {
                      if (isImojiOpen == true) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 300,
                            child: EmojiPicker(
                              onBackspacePressed: () {
                                model.toggleEmojiKeyboard.add(false);
                                model.focusNode.unfocus();
                              },
                              textEditingController: model.messageController,
                              onEmojiSelected: (category, emoji) {},
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    })
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet(BuildContext context) {
    return SizedBox(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }
}
