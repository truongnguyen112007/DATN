import 'package:base_bloc/data/model/notification_model.dart';
import 'package:base_bloc/modules/tab_notification/tab_notification_cubit.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/app_scalford.dart';
import '../../components/app_text.dart';
import '../../localization/locale_keys.dart';
import '../../theme/colors.dart';

class TabNotification extends StatefulWidget {
  const TabNotification({Key? key}) : super(key: key);

  @override
  State<TabNotification> createState() => _TabNotificationState();
}

class _TabNotificationState extends State<TabNotification>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  late final TabNotificationCubit _bloc;

  @override
  void initState() {
    _bloc = TabNotificationCubit();
    paging();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  void paging() {
    if (_scrollController.hasClients) {
      _scrollController.addListener(() {
        if (!_scrollController.hasClients) return;
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;
        if (currentScroll >= (maxScroll * 0.9)) _bloc.getFeed(isPaging: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorText5,
      appbar: AppBar(
        backgroundColor: colorGreen60,
        title: AppText(
          LocaleKeys.notification.tr(),
          style: googleFont.copyWith(
              color: colorSecondary10, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: const InkWell(
                child: Icon(
              Icons.settings,
              color: colorWhite,
            )),
          )
        ],
      ),
      body: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return itemNotification(fakeDataNotification()[index]);
        },
        separatorBuilder: (BuildContext context, int index) => SizedBox(height: 5.h,),
        itemCount: fakeDataNotification().length,
      ),
    );
  }

  Widget itemNotification(NotificationModel model) {
    return Container(
      height: 70.h,
      width: MediaQuery.of(context).size.width,
      color: colorBlue2,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.w),
            height: 30.h,
            width: 30.w,
            decoration: BoxDecoration(
                color: colorRed80.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100)),
            child: const Icon(
              Icons.report_gmailerrorred,
              color: colorRed80,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppText("${model.textNormal} ",style: googleFont.copyWith(color: colorBlack,fontSize: 14.sp,fontWeight: FontWeight.w500),),
                  AppText(model.textBool,style: googleFont.copyWith(color: colorBlack,fontSize: 14.sp,fontWeight: FontWeight.w700),)
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time,color: colorGrey50,size: 18.sp,),
                  SizedBox(
                    width: 10.w,
                  ),
                  AppText(model.time,style: googleFont.copyWith(color: colorGrey70),),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
