import 'package:flutter/cupertino.dart';

enum NewPageType { HOLD_SET,FILL_PLACE }

class NewPageEvent {
  final Widget newPage;
  final NewPageType? type;

  NewPageEvent(this.newPage, {this.type});
}
