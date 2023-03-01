import 'package:app/feature/chat_detail/chat_detail_page.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../navigation/route_paths.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.chatModel}) : super(key: key);
  final QBDialogEntity chatModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.chatDetail,
            arguments: ChatDetailPageArgs(
                dialogueId: chatModel.id ?? "",
                name: chatModel.name ?? "",
                lastSeenAt: chatModel.lastMessageDateSent ?? 0));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueGrey,
              child: SvgPicture.asset(
                chatModel.photo == null
                    ? "assets/person.svg"
                    : "assets/groups.svg",
                color: Colors.white,
                height: 36,
                width: 36,
              ),
            ),
            title: Text(
              chatModel.name ?? "",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                const Icon(Icons.done_all),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  chatModel.lastMessage ?? "",
                  style: const TextStyle(
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            //trailing: Text(chatModel.updatedAt?.substring(11, 16) ?? ""),
            trailing: Text(chatModel.lastMessageDateSent != null &&
                    chatModel.lastMessageDateSent! > 0
                ? _buildDate(chatModel.lastMessageDateSent!)
                : "no date"),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _buildDate(int timeStamp) {
    String completedDate = "";

    DateFormat todayFormat = DateFormat("HH:mm");
    DateFormat dayFormat = DateFormat("d MMMM");
    DateFormat lastYearFormat = DateFormat("dd.MM.yy");

    DateTime now = DateTime.now();
    DateTime messageTime =
        DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000);

    var yesterday = DateTime(now.year, now.month, now.day - 1);
    DateTime messageDate =
        DateTime(messageTime.year, messageTime.month, messageTime.day);

    if (now.difference(messageDate).inDays == 0) {
      completedDate = todayFormat.format(messageTime);
    } else if (yesterday == messageDate) {
      completedDate = "Yesterday";
    } else if (now.year == messageTime.year) {
      completedDate = dayFormat.format(messageTime);
    } else {
      completedDate = lastYearFormat.format(messageTime);
    }

    return completedDate;
  }
}
