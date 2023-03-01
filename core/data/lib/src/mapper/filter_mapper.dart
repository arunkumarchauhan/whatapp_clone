import 'package:data/data.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';

extension QBFilterMapper on QBFilterEntity {
  QBFilter restore() {
    var qbFilter = QBFilter();
    qbFilter.type = type;
    qbFilter.field = field;
    qbFilter.value = value;
    qbFilter.operator = operator;
    return qbFilter;
  }
}
