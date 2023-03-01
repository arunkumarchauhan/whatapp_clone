import 'package:app/feature/chat_list/chat_list_page.dart';
import 'package:app/feature/splash/CameraPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statemanagement_riverpod/statemanagement_riverpod.dart';

import 'home_view_model.dart';

class HomePageView extends BasePageViewWidget<HomePageViewModel> {
  HomePageView(ProviderBase<HomePageViewModel> model) : super(model);

  @override
  Widget build(BuildContext context, model) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "WhatsApp Clone",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {}),
          PopupMenuButton<String>(
            onSelected: (value) {
              print(value);
            },
            color: Colors.teal,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext contesxt) {
              return const [
                PopupMenuItem(
                  value: "New group",
                  child: Text("New group"),
                ),
                PopupMenuItem(
                  value: "New broadcast",
                  child: Text("New broadcast"),
                ),
                PopupMenuItem(
                  value: "Whatsapp Web",
                  child: Text("Whatsapp Web"),
                ),
                PopupMenuItem(
                  value: "Starred messages",
                  child: Text("Starred messages"),
                ),
                PopupMenuItem(
                  value: "Settings",
                  child: Text("Settings"),
                ),
              ];
            },
          )
        ],
        bottom: TabBar(
          controller: model.tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              icon: Icon(Icons.camera_alt),
            ),
            Tab(
              text: "CHATS",
            ),
            Tab(
              text: "STATUS",
            ),
            Tab(
              text: "CALLS",
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: model.tabController,
        children: const [
          CameraPage(),
          ChatListPage(),
          // ChatPage(
          //   chatmodels: chatmodels,
          //   sourchat: chatmodels[0],
          // ),
          Text("STATUS"),
          Text("Calls"),
        ],
      ),
    );
  }
}
