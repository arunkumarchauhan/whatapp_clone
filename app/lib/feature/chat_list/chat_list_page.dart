import 'package:app/di/states/viewmodels.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statemanagement_riverpod/statemanagement_riverpod.dart';

import 'chat_list_model.dart';
import 'chat_list_page_view.dart';

class ChatListPage extends BasePage<ChatListViewModel> {
  const ChatListPage({Key? key}) : super(key: key);
  @override
  ChatListPageState createState() {
    return ChatListPageState();
  }
}

class ChatListPageState
    extends BaseStatefulPage<ChatListViewModel, ChatListPage> {
  @override
  Widget buildView(BuildContext context, ChatListViewModel model) {
    return ChatListPageView(provideBase());
  }

  @override
  ProviderBase<ChatListViewModel> provideBase() {
    return chatListViewModelProvider;
  }
}
