import 'package:domain/domain.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';

extension QBSortMapper on QBSortEntity {
  QBSort restore() {
    final qbSort = QBSort();
    qbSort.field = field;
    qbSort.type = type;
    qbSort.ascending = ascending;
    return qbSort;
  }
}
