/// Support for doing something awesome.
///
/// More dartdocs go here.
library domain;

export 'src/di/domain_dependency_configurator.dart';
export 'package:dartz/dartz.dart';

//repository contracts
export 'src/repository/user_repository.dart';
export 'src/repository/qb_user_repository.dart';
export 'src/repository/auth_repository.dart';
export 'src/repository/setting_repository.dart';
export 'src/repository/chat_repository.dart';
export 'src/repository/content_repository.dart';
export 'src/repository/custom_object_repository.dart';
export 'src/repository/event_repository.dart';
export 'src/repository/storage_repository.dart';
export 'src/repository/subscription_repository.dart';

//use-cases
export 'src/usecase/base/params.dart';
export 'src/usecase/user/login_usecase.dart';
export 'package:shared/shared.dart';
