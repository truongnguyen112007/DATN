import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/notification_widget.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/app_scalford.dart';
import '../../../../components/appbar_widget.dart';
import '../../components/app_circle_loading.dart';
import '../../components/app_text.dart';
import '../../data/globals.dart';
import '../../data/model/notification_model.dart';
import '../../theme/app_styles.dart';
import 'notifications_cubit.dart';
import 'notifications_state.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsState();
}

class _NotificationsState extends BaseState<NotificationsPage>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  late final NotificationsCubit _bloc;

  @override
  void initState() {
    _bloc = NotificationsCubit();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        padding: EdgeInsets.only(top: contentPadding),
        backgroundColor: colorGreyBackground,
        appbar:
            appBarWidget(context: context, titleStr: LocaleKeys.notifications),
        body: RefreshIndicator(
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: notificationsWidget(),
              ),
              BlocBuilder<NotificationsCubit, NotificationsState>(
                bloc: _bloc,
                builder: (BuildContext context, state) =>
                    (state.status == NotificationsStatus.initial ||
                            state.status == NotificationsStatus.refresh)
                        ? const Center(
                            child: AppCircleLoading(),
                          )
                        : const SizedBox(),
              )
            ],
          ),
          onRefresh: () async => _bloc.refresh(),
        ));
  }

  Widget notificationsWidget() =>
      BlocBuilder<NotificationsCubit, NotificationsState>(
        bloc: _bloc,
        builder: (BuildContext context, state) {
          Widget? widget;
          if (state.status == NotificationsStatus.initial ||
              state.status == NotificationsStatus.refresh) {
            widget = const SizedBox();
          } else if (state.status == NotificationsStatus.success) {
            widget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                titleHeaderWidget(AppLocalizations.of(context)!.invitations),
                lNotificationsWidget(state.lInvitations, true),
                titleHeaderWidget(AppLocalizations.of(context)!.activities),
                lNotificationsWidget(state.lActivities, false),
                const SizedBox(
                  height: 20,
                )
              ],
            );
          }
          return widget!;
        },
      );

  Widget lNotificationsWidget(
          List<NotificationModel> list, bool isInvitation) =>
      ListView.separated(
        padding: EdgeInsets.only(left: contentPadding, right: contentPadding),
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        itemBuilder: (BuildContext context, int index) => (index == list.length)
            ? const Center(child: AppCircleLoading())
            : itemNotificationWidget(list[index], isInvitation,
                onClickAddToFriends: () {
                logE('onClickAddToFriends');
              }, onClickReject: () {
                logE('onClickReject');
              }),
        itemCount: list.length,
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) => SizedBox(
          height: 8.w,
        ),
      );

  @override
  bool get wantKeepAlive => true;
}
