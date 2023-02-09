import 'package:base_bloc/data/globals.dart';

import '../../gen/assets.gen.dart';
import '../../modules/tab_profile/edit_settings/edit_settings_cubit.dart';

class NotificationModel {
  String? image;
  String? title;
  String? content;
  String? date;
  String? type;

  NotificationModel(
      {String? image = null,
        String? title = null,
        String? content: null,
        String? date: null,
        String? type: null}) {
    this.image = image;
    this.title = title;
    this.content = content;
    this.date = date;
    this.type = type;
  }
}
