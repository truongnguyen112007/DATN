import 'package:base_bloc/data/model/feed_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../gen/assets.gen.dart';
import '../localizations/app_localazations.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';
import '../utils/toast_utils.dart';
import 'app_text.dart';

class ButtonPlayListHome extends StatefulWidget {
  final FeedModel model;

  const ButtonPlayListHome({Key? key, required this.model}) : super(key: key);

  @override
  State<ButtonPlayListHome> createState() => _ButtonPlayListHomeState();
}

class _ButtonPlayListHomeState extends State<ButtonPlayListHome> {
  String assetName = '';

  @override
  void initState() {
    assetName = widget.model.isAddToPlaylist
        ? Assets.svg.removepl
        : Assets.svg.addToPlayList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.model.isAddToPlaylist = !widget.model.isAddToPlaylist;
        assetName = widget.model.isAddToPlaylist
            ? Assets.svg.removepl
            : Assets.svg.addToPlayList;
        toast(widget.model.isAddToPlaylist
            ? 'The route has been added to Playlist'
            : 'The route has been removed from Playlist');
        setState(() {});
      },
      child: actionWidget(
          SizedBox(
            width: 24,
            child: SvgPicture.asset(
              assetName,
              color: colorWhite,
            ),
          ),
          LocaleKeys.playlist),
    );
  }

  Widget actionWidget(Widget title, String content) => SizedBox(
        height: 38.h,
        child: Column(
          children: [
            Expanded(
                child: Align(
              alignment: Alignment.topLeft,
              child: title,
            )),
            AppText(
              content,
              style: googleFont.copyWith(
                  fontSize: 11.sp, color: colorText0.withOpacity(0.87)),
            ),
          ],
        ),
      );
}
