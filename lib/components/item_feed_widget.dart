import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/app_circle_image.dart';
import 'package:base_bloc/components/app_video.dart';
import 'package:base_bloc/components/thumbnail_app.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/model/feed_model.dart';
import '../gen/assets.gen.dart';
import '../theme/colors.dart';
import 'app_like_button.dart';
import 'app_text.dart';

enum FeedAction { ADD_PLAYLIST, LIKE, MORE, SHOW_MORE }

class ItemFeed extends StatefulWidget {
  final FeedModel model;
  final int index;

  const ItemFeed({Key? key, required this.model, required this.index})
      : super(key: key);

  @override
  State<ItemFeed> createState() => _ItemFeedState();
}

class _ItemFeedState extends State<ItemFeed> {
  bool isLike = false;
  var avatar =
      'https://thegioidienanh.vn/stores/news_dataimages/anhvu/092022/05/07/4955_300520026_497051069095370_6964118069725518096_n.jpg?rt=20220905075129';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: colorMainBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          infoAuthorWidget(context),
          widget.model.videoURL.isNotEmpty
              ? ThumbnailApp(
                  callbackOpenVideo: () => RouterUtils.openNewPage(
                      AppVideo(
                        model: widget.model,
                        index: widget.index,
                      ),
                      context))
              : widget.model.photoURL != null &&
                      widget.model.photoURL!.isNotEmpty
                  ? Image.asset(widget.model.photoURL ?? '')
                  : const SizedBox(),
          infoGradeWidget(context),
          widget.model.isShowInfomation
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                      // child: Column()
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          actionWidget(
                              SvgPicture.asset(
                                Assets.svg.os,
                                width: 25.w,
                              ),
                              'On sight'),
                          actionWidget(
                              AppText(
                                '8A',
                                style: typoLargeText700.copyWith(
                                    height: 1,
                                    fontSize: 25.5.sp,
                                    color: colorText0.withOpacity(0.87)),
                              ),
                              'Grade'),
                          actionWidget(
                              SvgPicture.asset(
                                Assets.svg.addPlayList,
                                width: 30.w,
                              ),
                              LocaleKeys.playlist),
                        ],
                      ),
                    ),
                    itemSpaceVertical(),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: AppText(
                        'Belay: Toprope',
                        style: typoSmallTextRegular.copyWith(
                            fontSize: 13.5.sp,
                            color: colorText0.withOpacity(0.87)),
                      ),
                    ),
                    itemSpaceVertical(height: 5),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: AppText(
                        'Support: Yes',
                        style: typoSmallTextRegular.copyWith(
                            fontSize: 13.5.sp,
                            color: colorText0.withOpacity(0.87)),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.only(left: 10.w, bottom: 10.h, top: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      actionWidget(
                          SvgPicture.asset(
                            Assets.svg.os,
                            fit: BoxFit.cover,
                          ),
                          'On sight'),
                      actionWidget(
                          SvgPicture.asset(
                            Assets.svg.addPlayList,
                            width: 30.w,
                          ),
                          LocaleKeys.playlist),
                    ],
                  ),
                ),
          itemSpaceVertical(),
          Divider(
            thickness: 0.2.h,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(left: contentPadding),
            child: Row(
              children: [
                const AppLikeButton(),
                itemSpaceHorizontal(width: 20),
                actionWidget(SvgPicture.asset(Assets.svg.comment),
                    '10 ${LocaleKeys.comment}')
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.w, top: 10.h, bottom: 10.h),
            child: Row(
              children: [
                AppCircleImage(
                  width: 29.w,
                  height: 29.w,
                  urlError: '',
                  url: avatar,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppText(
                            'Zoe Smith',
                            style: typoSuperSmallText700.copyWith(
                                fontSize: 13.sp,
                                color: colorText0.withOpacity(0.87)),
                          ),
                          Expanded(
                              child: AppText(
                            " - There is just one word to die",
                            style: typoSuperSmallTextRegular.copyWith(
                                fontSize: 13.sp,
                                color: colorText0.withOpacity(0.87)),
                            overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      ),
                      InkWell(
                        onTap: () => handleAction(FeedAction.SHOW_MORE),
                        child: AppText(
                          LocaleKeys.show_more,
                          style: typoSuperSmallTextRegular.copyWith(
                              fontSize: 13.sp,
                              color: colorText0.withOpacity(0.6)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget itemSpaceHorizontal({double width = 11}) => SizedBox(width: width);

  Widget itemSpaceVertical({double height = 10}) => SizedBox(height: height);

  Widget infoAuthorWidget(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6, left: 10, right: 10),
        child: Row(
          children: [
            AppCircleImage(
              width: 40.w,
              height: 40.w,
              urlError: '',
              url: avatar,
            ),
            itemSpaceHorizontal(width: 15.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Adam Kowalski',
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                      style: typoLargeText700.copyWith(
                          color: colorMainText, fontSize: 22.sp),
                    ),
                    Row(
                      children: [
                        AppText('2h',
                            style: typoSmallTextRegular.copyWith(
                                fontSize: 13.sp, color: colorSubText)),
                        itemSpaceHorizontal(),
                        Container(
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(100)),
                        ),
                        itemSpaceHorizontal(),
                        AppText('Murall',
                            style: typoSmallTextRegular.copyWith(
                                fontSize: 13.sp, color: colorSubText)),
                        itemSpaceHorizontal(),
                        const Icon(
                          Icons.public,
                          color: Colors.grey,
                          size: 18,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => handleAction(FeedAction.MORE),
              child: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );

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
              style: typoSuperSmallTextRegular.copyWith(
                  fontSize: 11.sp, color: colorText0.withOpacity(0.87)),
            )
          ],
        ),
      );

  Widget infoGradeWidget(BuildContext context) => Container(
        height: 65.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              HexColor('D10000'),
              HexColor('D10000'),
              HexColor('D15B00')
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            itemSpaceHorizontal(),
            AppText(
              "8A",
              style: typoLargeText700.copyWith(
                  fontSize: 28.5.sp, color: colorText0.withOpacity(0.87)),
            ),
            SizedBox(
              width: 30.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Adam 2022-05-02',
                  style: typoLargeText700.copyWith(
                      fontSize: 21.5.sp, color: colorText0.withOpacity(0.87)),
                ),
                Center(
                  child: Row(
                    children: [
                      AppText(
                        'Routes 12m',
                        style: typoSuperSmallTextRegular.copyWith(
                            color: colorText0.withOpacity(0.6)),
                      ),
                      itemSpaceHorizontal(width: 5),
                      Icon(
                        Icons.circle_sharp,
                        size: 8,
                        color: Colors.grey[400],
                      ),
                      itemSpaceHorizontal(width: 5),
                      AppText(
                        'Adam Kowalski',
                        style: typoSuperSmallTextRegular.copyWith(
                            color: colorText0.withOpacity(0.6)),
                      ),
                    ],
                  ),
                )
              ], //191019
            )
          ],
        ),
      );

  void handleAction(FeedAction action) => logE("TAG ACTION: $action");
}
