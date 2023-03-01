import 'package:data/data.dart';
import 'package:data/src/repository/auth_repository_impl.dart';
import 'package:data/src/repository/chat_repository_impl.dart';
import 'package:data/src/repository/content_repository_impl.dart';
import 'package:data/src/repository/custom_object_repository.dart';
import 'package:data/src/repository/events_repository.dart';
import 'package:data/src/repository/qb_user_repository.dart';
import 'package:data/src/repository/setting_repository_impl.dart';
import 'package:data/src/repository/storage_repository.dart';
import 'package:data/src/repository/subscription_repository.dart';
import 'package:data/src/repository/user_repository.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DataModule {
  @lazySingleton
  UserRepository userRepositoryProvider(
      DatabasePort databasePort, NetworkPort networkPort) {
    return UserRepositoryImpl(databasePort, networkPort);
  }

  @lazySingleton
  AuthRepository authRepositoryProvider() {
    return AuthRepositoryImpl();
  }

  @lazySingleton
  ChatRepository chatRepositoryProvider() {
    return ChatRepositoryImpl();
  }

  @lazySingleton
  ContentRepository contentRepositoryProvider() {
    return ContentRepositoryImpl();
  }

  @lazySingleton
  CustomObjectsRepository customObjectRepositoryProvider() {
    return CustomObjectsRepositoryImpl();
  }

  @lazySingleton
  EventsRepository eventsRepositoryProvider() {
    return EventsRepositoryImpl();
  }

  @lazySingleton
  QBUserRepository qbUserRepositoryProvider(NetworkPort networkPort) {
    return QBUserRepoImpl(networkPort: networkPort);
  }

  @lazySingleton
  SettingsRepository settingRepositoryProvider() {
    return SettingsRepositoryImpl();
  }

  @lazySingleton
  StorageRepository storageRepositoryProvider() {
    return StorageRepositoryImpl();
  }

  @lazySingleton
  SubscriptionsRepository subscriptionRepositoryProvider() {
    return SubscriptionsRepositoryImpl();
  }
}
