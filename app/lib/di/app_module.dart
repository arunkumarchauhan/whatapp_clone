import 'package:injectable/injectable.dart';
import 'package:app/flavors/flavor_config.dart';

@module
abstract class AppModule {
  @Named("BaseUrl")
  String get baseUrl => FlavorConfig.instance.values.apiBaseUrl;
}
