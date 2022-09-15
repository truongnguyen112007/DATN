import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/playlist_model.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/playlist/playlist_cubit.dart';
import 'package:base_bloc/modules/playlist/playlist_state.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayListPage extends StatefulWidget {
  const PlayListPage({Key? key}) : super(key: key);

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage>
    with AutomaticKeepAliveClientMixin {
  late PlayListCubit _bloc;
  var scrollController = ScrollController();

  @override
  void initState() {
    _bloc = PlayListCubit();
    paging();
    super.initState();
  }

  void paging() {
    scrollController.addListener(() {
      var maxScroll = scrollController.position.maxScrollExtent;
      var currentScroll = scrollController.position.pixels;
      if (maxScroll - currentScroll <= 200) {
        _bloc.getPlaylist(isPaging: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
            child: BlocBuilder<PlayListCubit, PlaylistState>(
                bloc: _bloc,
                builder: (c, state) {
                  if (state.status == FeedStatus.initial ||
                      state.status == FeedStatus.refresh) {
                    return const Center(
                      child: AppCircleLoading(),
                    );
                  }
                  return playlistWidget(context, state);
                }),
            onRefresh: () async => _bloc.onRefresh()),
        Positioned.fill(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      child: Container(
                          width: 45.w,
                          height: 45.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              gradient: const LinearGradient(
                                  colors: [colorOrange110, colorOrange100])),
                          child: const Icon(
                            Icons.add,
                            color: colorWhite,
                          )),
                    ))))
      ],
    );
  }

  Widget playlistWidget(BuildContext context, PlaylistState state) =>
      ListView.separated(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(contentPadding),
          itemBuilder: (c, i) => i == state.lPlayList.length
              ? const Center(
                  child: AppCircleLoading(),
                )
              : itemPlayList(context, state.lPlayList[i], (model) {}),
          separatorBuilder: (x, i) => const SizedBox(
                height: 10,
              ),
          itemCount:
              !state.isReadEnd && state.lPlayList.isNotEmpty && state.isLoading
                  ? state.lPlayList.length + 1
                  : state.lPlayList.length);

  Widget itemPlayList(BuildContext context, PlayListModel model,
          Function(PlayListModel model) callBack) =>
      Container(
        padding: EdgeInsets.only(
            left: contentPadding + 10, right: contentPadding + 10),
        height: 75.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(colors: getBackgroundColor(model.grade))),
        child: InkWell(
            onTap: () => callBack.call(model),
            splashColor: Colors.amber,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                model.status == null
                    ? AppText(
                        model.grade,
                        style: typoLargeTextRegular.copyWith(
                            color: colorText0, fontSize: 33.sp),
                        textAlign: TextAlign.end,
                      )
                    : Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: AppText(
                              model.grade,
                              style: typoLargeTextRegular.copyWith(
                                  color: colorText0, fontSize: 33.sp),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Positioned.fill(
                              child: Container(
                            alignment: Alignment.bottomCenter,
                            child: AppText(
                              model.status ?? '',
                              textAlign: TextAlign.center,
                              style: typoSuperSmallText300.copyWith(
                                  color: colorText0),
                            ),
                          ))
                        ],
                      ),
                SizedBox(
                  width: 22.w,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      model.name,
                      style: typoLargeTextRegular.copyWith(
                          color: colorText0, fontSize: 23.sp),
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        AppText(
                          '${AppLocalizations.of(context)!.routes} ${model.height}m ',
                          style: typoSmallText300.copyWith(color: colorText0),
                        ),
                        const Icon(
                          Icons.ac_unit_rounded,
                          size: 6,
                          color: colorWhite,
                        ),
                        Expanded(
                            child: AppText(
                          " ${model.author} jdsh klsjhd lsjd lskdj sldkj",
                          overflow: TextOverflow.ellipsis,
                          maxLine: 1,
                          style: typoSmallText300.copyWith(color: colorText0),
                        ))
                      ],
                    )
                  ],
                ))
              ],
            )),
      );

  List<Color> getBackgroundColor(String value) {
    switch (value) {
      case '4':
        return [colorGreen70, colorGreen70];
      case '5A':
        return [
          colorOrange80,
          colorGreen70,
          colorGreen70,
          colorGreen70,
          colorGreen70
        ];
      case '5C':
        return [colorOrange80, colorGreen70, colorGreen70];
      case '6A':
        return [colorOrange80, colorGreen70, colorGreen70];
      case '7B':
        return [colorRed80, colorOrange80, colorOrange80];
      case '8A':
        return [colorRed100, colorRed90, colorOrange110];
      case '5B':
        return [colorOrange110, colorGreen50, colorGreen55];
      default:
        return [
          colorRed100,
          colorRed100,
        ];
    }
  }

  @override
  bool get wantKeepAlive => true;
}
