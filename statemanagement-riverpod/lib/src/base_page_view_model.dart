import 'base_view_model.dart';
import 'package:rxdart/rxdart.dart';

class BasePageViewModel extends BaseViewModel {
  BehaviorSubject<bool> loadingSubject = BehaviorSubject.seeded(false);
}
