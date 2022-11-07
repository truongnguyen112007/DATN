import 'package:flutter/cupertino.dart';

enum NewPageType { HOLD_SET, FILL_PLACE, ZOOM_ROUTES }

class NewPageEvent {
  final Widget newPage;
  final bool isReplace;
  final NewPageType? type;

  NewPageEvent(this.newPage, {this.type, this.isReplace = false});
}
