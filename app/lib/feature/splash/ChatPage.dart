import 'package:app/feature/splash/SelectContact.dart';
import 'package:app/model/chat_model.dart';
import 'package:app/ui_molecules/cards/CustomCard.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.chatmodels, required this.sourchat})
      : super(key: key);
  final List<ChatModel> chatmodels;
  final ChatModel sourchat;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const SelectContact()));
        },
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: widget.chatmodels.length,
        itemBuilder: (contex, index) => CustomCard(
          chatModel: QBDialogEntity(),
          sourchat: widget.sourchat,
        ),
      ),
    );
  }
}
