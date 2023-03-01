import 'package:app/ui_molecules/cards/CustomCard.dart';
import 'package:app/utils/app_toast.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statemanagement_riverpod/statemanagement_riverpod.dart';

import '../../model/resource.dart';
import '../../utils/stream_builder/app_stream_builder.dart';
import 'chat_list_model.dart';

class ChatListPageView extends BasePageViewWidget<ChatListViewModel> {
  ChatListPageView(ProviderBase<ChatListViewModel> model) : super(model);

  @override
  Widget build(BuildContext context, model) {
    return AppStreamBuilder<Resource<List<QBDialogEntity?>>>(
      stream: model.chatListStream,
      initialData: Resource.none(),
      onData: (data) {
        if (data.status == Status.error) {
          AppToast.showToast(data.dealSafeAppError?.error.message);
        }
      },
      dataBuilder: (context, data) {
        if (data?.status == Status.success) {
          debugPrint("qbDialogueList LENGTH :  ${data?.data?.length} ");
          List<QBDialogEntity?>? qbDialogueList = data!.data;
          return ListView.builder(
              itemCount: qbDialogueList?.length ?? 0,
              itemBuilder: ((context, index) {
                QBDialogEntity? dialogue = qbDialogueList![index];
                if (dialogue == null) {
                  return const SizedBox.shrink();
                }
                return CustomCard(
                  chatModel: dialogue,
                );
              }));
        }
        return const Center(
          child: Text(
            "No Users found",
          ),
        );
        // return ChatPage(
        //   chatmodels: chatmodels,
        //   sourchat: chatmodels[0],
        // );
      },
    );
  }
}
