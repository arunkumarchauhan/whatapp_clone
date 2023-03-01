import '../model/chat_model.dart';

List<ChatModel> contacts = [
  ChatModel(name: "Dev Stack", status: "A full stack developer"),
  ChatModel(name: "Balram", status: "Flutter Developer..........."),
  ChatModel(name: "Saket", status: "Web developer..."),
  ChatModel(name: "Bhanu Dev", status: "App developer...."),
  ChatModel(name: "Collins", status: "Raect developer.."),
  ChatModel(name: "Kishor", status: "Full Stack Web"),
  ChatModel(name: "Testing1", status: "Example work"),
  ChatModel(name: "Testing2", status: "Sharing is caring"),
  ChatModel(name: "Divyanshu", status: "....."),
  ChatModel(name: "Helper", status: "Love you Mom Dad"),
  ChatModel(name: "Tester", status: "I find the bugs"),
];
List<ChatModel> groupmember = [];
List<ChatModel> chatmodels = [
  ChatModel(
    name: "Dev Stack",
    isGroup: false,
    currentMessage: "Hi Everyone",
    time: "4:00",
    icon: "person.svg",
    id: 1,
  ),
  ChatModel(
    name: "Kishor",
    isGroup: false,
    currentMessage: "Hi Kishor",
    time: "13:00",
    icon: "person.svg",
    id: 2,
  ),

  ChatModel(
    name: "Collins",
    isGroup: false,
    currentMessage: "Hi Dev Stack",
    time: "8:00",
    icon: "person.svg",
    id: 3,
  ),

  ChatModel(
    name: "Balram Rathore",
    isGroup: false,
    currentMessage: "Hi Dev Stack",
    time: "2:00",
    icon: "person.svg",
    id: 4,
  ),

  // ChatModel(
  //   name: "NodeJs Group",
  //   isGroup: true,
  //   currentMessage: "New NodejS Post",
  //   time: "2:00",
  //   icon: "group.svg",
  // ),
];
const String DEFAULT_USER_PASSWORD = "quickblox";

const String APPLICATION_ID = "99355";
const String AUTH_KEY = "YhFaZjPYvyJuTJ6";
const String AUTH_SECRET = "yXJvZ2yX8AtvhaW";
const String ACCOUNT_KEY = "fYjBThvuk-bAdQKCp1yr";

class QBChatDialogTypes {
  ///////////////////////////////////////////////////////////////////////////
  // DIALOG TYPES
  ///////////////////////////////////////////////////////////////////////////
  static const PUBLIC_CHAT = 1;
  static const GROUP_CHAT = 2;
  static const CHAT = 3;
}

class QBChatEvents {
  ///////////////////////////////////////////////////////////////////////////
  // EVENTS
  ///////////////////////////////////////////////////////////////////////////
  static const CONNECTED = "${Chat.CHANNEL_NAME}/CONNECTED";
  static const CONNECTION_CLOSED = "${Chat.CHANNEL_NAME}/CONNECTION_CLOSED";
  static const RECONNECTION_FAILED = "${Chat.CHANNEL_NAME}/RECONNECTION_FAILED";
  static const RECONNECTION_SUCCESSFUL =
      "${Chat.CHANNEL_NAME}/RECONNECTION_SUCCESSFUL";
  static const RECEIVED_NEW_MESSAGE =
      "${Chat.CHANNEL_NAME}/RECEIVED_NEW_MESSAGE";
  static const RECEIVED_SYSTEM_MESSAGE =
      "${Chat.CHANNEL_NAME}/RECEIVED_SYSTEM_MESSAGE";
  static const MESSAGE_DELIVERED = "${Chat.CHANNEL_NAME}/MESSAGE_DELIVERED";
  static const MESSAGE_READ = "${Chat.CHANNEL_NAME}/MESSAGE_READ";
  static const USER_IS_TYPING = "${Chat.CHANNEL_NAME}/USER_IS_TYPING";
  static const USER_STOPPED_TYPING = "${Chat.CHANNEL_NAME}/USER_STOPPED_TYPING";
}

class QBChatDialogSorts {
  ///////////////////////////////////////////////////////////////////////////
  // DIALOG SORTS
  ///////////////////////////////////////////////////////////////////////////
  static const LAST_MESSAGE_DATE_SENT = "last_message_date_sent";
}

class QBChatDialogFilterFields {
  ///////////////////////////////////////////////////////////////////////////
  // DIALOG FILTER FIELDS
  ///////////////////////////////////////////////////////////////////////////
  static const ID = "_id";
  static const TYPE = "type";
  static const NAME = "name";
  static const LAST_MESSAGE_DATE_SENT = "last_message_date_sent";
  static const CREATED_AT = "created_at";
  static const UPDATED_AT = "updated_at";
}

class QBChatDialogFilterOperators {
  ///////////////////////////////////////////////////////////////////////////
  // DIALOG FILTER OPERATORS
  ///////////////////////////////////////////////////////////////////////////
  static const LT = "lt";
  static const LTE = "lte";
  static const GT = "gt";
  static const GTE = "gte";
  static const NE = "ne";
  static const IN = "in";
  static const NIN = "nin";
  static const ALL = "all";
  static const CTN = "ctn";
}

class QBChatMessageSorts {
  ///////////////////////////////////////////////////////////////////////////
  // MESSAGE SORTS
  ///////////////////////////////////////////////////////////////////////////
  static const DATE_SENT = "date_sent";
}

class QBChatMessageFilterFields {
  ///////////////////////////////////////////////////////////////////////////
  // MESSAGE FILTER FIELDS
  ///////////////////////////////////////////////////////////////////////////
  static const ID = "_id";
  static const BODY = "message";
  static const DATE_SENT = "date_sent";
  static const SENDER_ID = "sender_id";
  static const RECIPIENT_ID = "recipient_id";
  static const ATTACHMENTS_TYPE = "attachments_type";
  static const UPDATED_AT = "updated_at";
}

class QBChatMessageFilterOperators {
  ///////////////////////////////////////////////////////////////////////////
  // MESSAGE FILTER OPERATORS
  ///////////////////////////////////////////////////////////////////////////
  static const LT = "lt";
  static const LTE = "lte";
  static const GT = "gt";
  static const GTE = "gte";
  static const NE = "ne";
  static const IN = "in";
  static const NIN = "nin";
  static const OR = "or";
  static const CTN = "ctn";
}

class Chat {
  const Chat();

  ///////////////////////////////////////////////////////////////////////////
  // CHAT MODULE
  ///////////////////////////////////////////////////////////////////////////

  //Channel name
  static const CHANNEL_NAME = "FlutterQBChatChannel";

  //Methods
  static const CONNECT_METHOD = "connect";
  static const DISCONNECT_METHOD = "disconnect";
  static const IS_CONNECTED_METHOD = "isConnected";
  static const PING_SERVER_METHOD = "pingServer";
  static const PING_USER_METHOD = "pingUser";
  static const GET_DIALOGS_METHOD = "getDialogs";
  static const GET_DIALOGS_COUNT_METHOD = "getDialogsCount";
  static const UPDATE_DIALOG_METHOD = "updateDialog";
  static const CREATE_DIALOG_METHOD = "createDialog";
  static const DELETE_DIALOG_METHOD = "deleteDialog";
  static const LEAVE_DIALOG_METHOD = "leaveDialog";
  static const JOIN_DIALOG_METHOD = "joinDialog";
  static const IS_JOINED_DIALOG_METHOD = "isJoinedDialog";
  static const GET_ONLINE_USERS_METHOD = "getOnlineUsers";
  static const SEND_MESSAGE_METHOD = "sendMessage";
  static const SEND_SYSTEM_MESSAGE_METHOD = "sendSystemMessage";
  static const MARK_MESSAGE_READ_METHOD = "markMessageRead";
  static const SEND_IS_TYPING_METHOD = "sendIsTyping";
  static const SEND_STOPPED_TYPING_METHOD = "sendStoppedTyping";
  static const MARK_MESSAGE_DELIVERED_METHOD = "markMessageDelivered";
  static const GET_DIALOG_MESSAGES_METHOD = "getDialogMessages";
  static const GET_TOTAL_UNREAD_MESSAGES_COUNT_METHOD =
      "getTotalUnreadMessagesCount";
}
