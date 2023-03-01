import 'package:rxdart/rxdart.dart';

extension SafeAddExtension on Subject {
  void safeAdd(dynamic data) {
    if (!isClosed) {
      add(data);
    }
  }
}
