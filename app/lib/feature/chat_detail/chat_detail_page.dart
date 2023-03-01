// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app/di/states/viewmodels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statemanagement_riverpod/statemanagement_riverpod.dart';

import 'chat_page_view.dart';
import 'chat_view_model.dart';

class ChatDetailPage extends BasePage<ChatDetailViewModel> {
  ChatDetailPageArgs args;
  ChatDetailPage({Key? key, required this.args}) : super(key: key);

  @override
  ChatDetailPageState createState() => ChatDetailPageState();
}

class ChatDetailPageState
    extends BaseStatefulPage<ChatDetailViewModel, ChatDetailPage>
    with SingleTickerProviderStateMixin {
  @override
  ProviderBase<ChatDetailViewModel> provideBase() {
    return chatDetailViewModelProvider.call(widget.args);
  }

  @override
  void onModelReady(ChatDetailViewModel model) {
    // bind exception handler here.
  }

  @override
  bool extendBodyBehindAppBar() {
    return true;
  }

  @override
  Future<bool> onBackPressed({dynamic param}) {
    final vm = getViewModel();
    if (vm.focusNode.hasFocus == false &&
        vm.toggleEmojiKeyboard.value == false) {
      vm.focusNode.unfocus();
      vm.toggleEmojiKeyboard.add(false);
      Navigator.pop(context);
      return Future.value(false);
    } else if (vm.focusNode.hasFocus || vm.toggleEmojiKeyboard.value) {
      vm.focusNode.unfocus();
      vm.toggleEmojiKeyboard.add(false);
      return Future.value(false);
    } else {
      return super.onBackPressed(param: param);
    }
  }

  @override
  Widget buildView(BuildContext context, ChatDetailViewModel model) {
    return ChatDetailView(provideBase());
  }
}

class ChatDetailPageArgs {
  String dialogueId;
  String name;
  int lastSeenAt;
  ChatDetailPageArgs({
    required this.dialogueId,
    required this.name,
    required this.lastSeenAt,
  });

  @override
  String toString() =>
      'ChatDetailPageArgs(dialogueId: $dialogueId, name: $name lastSeenAt: $lastSeenAt)';
}
