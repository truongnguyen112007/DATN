import 'dart:async';
import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/filter_widget.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/places_model.dart';
import 'package:base_bloc/modules/places_page/places_page_cubit.dart';
import 'package:base_bloc/modules/places_page/places_page_state.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../components/app_text.dart';
import '../../data/eventbus/hide_map_event.dart';
import '../../data/eventbus/search_home_event.dart';
import '../../gen/assets.gen.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_styles.dart';
import '../../theme/colors.dart';
import '../../utils/app_utils.dart';

class PlacesPage extends StatefulWidget {
  final int index;
  final int root;
  final Function(bool isShow) onCallBackShowMap;

  const PlacesPage(
      {Key? key, required this.index, required this.onCallBackShowMap, required this.root})
      : super(key: key);

  @override
  State<PlacesPage> createState() => _PlacesPageState();
}

final List<String> wallHeight = [
  '6m',
  '8m',
  '12m',
];

final List<String> holdSet = [
  'Standard',
  'Custom',
];

final List<String> itemCity = ['item1', 'item2', 'item3'];

class _PlacesPageState extends State<PlacesPage>
    with AutomaticKeepAliveClientMixin {
  String? selectedValue = itemCity[0];
  int selectedHeight = 0;
  int selectedHold = 0;
  bool isShowMap = false;
  Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _kGooglePlex;
  final Set<Marker> markers = new Set();
  StreamSubscription<HideMapEvent>? _hideMapStream;
  StreamSubscription<SearchHomeEvent>? _searchStream;

  late PlacesPageCubit _bloc;

  @override
  void initState() {
    _bloc = PlacesPageCubit(widget.root);
    _searchStream = Utils.eventBus.on<SearchHomeEvent>().listen((event) {
      if (event.index == widget.index) {}
    });
    _hideMapStream = Utils.eventBus.on<HideMapEvent>().listen((event) {
      isShowMap = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _hideMapStream?.cancel();
    _searchStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: Stack(
          children: [
            ListView(),
            BlocBuilder<PlacesPageCubit, PlacesPageState>(
                bloc: _bloc,
                builder: (c, state) {
                  if (state.isLoading && state.lPlayList.isEmpty) {
                    return const Center(child: AppCircleLoading());
                  }
                  if (state.status == FeedStatus.success &&
                      state.lPlayList.isNotEmpty) {
                    _kGooglePlex = CameraPosition(
                        target: LatLng(
                            state.lPlayList[0].lat, state.lPlayList[0].lng),
                        zoom: 15);
                    for (int i = 0; i < state.lPlayList.length; i++) {
                      markers.add(Marker(
                          markerId: MarkerId(i.toString()),
                          position: LatLng(
                              state.lPlayList[i].lat, state.lPlayList[i].lng)));
                    }
                  }
                  return Container(
                    color: const Color(0xFF282D2F),
                    child: Column(
                      children: [
                        FilterWidget(
                          sortCallBack: () {},
                          filterCallBack: () {
                            showModalBottomSheet<void>(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return filterDiaLog();
                              },
                            );
                          },
                          selectCallBack: () {},
                          isSelect: false,
                          unsSelectCallBack: () {},
                        ),
                        Expanded(
                          child: Stack(children: [
                            googleMap(),
                            infoPlaceWidget(),
                            changeUiWidget()
                          ]),
                        ),
                      ],
                    ),
                  );
                })
          ],
        ),
        onRefresh: () async {
          _bloc.onRefresh();
        });
  }

  Widget titleWidget(String title) => Padding(
      padding: EdgeInsets.only(left: contentPadding, top: contentPadding),
      child: AppText(title.toUpperCase(),
          style: typoW600.copyWith(
              color: colorText0.withOpacity(0.87), fontSize: 9.sp)));

  Widget infoPlaceWidget() => BlocBuilder<PlacesPageCubit, PlacesPageState>(
        bloc: _bloc,
        builder: (BuildContext context, state) => Visibility(
          visible: !isShowMap,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: state.lLastPlace.isNotEmpty,
                  child: Row(
                    children: [
                      titleWidget(LocaleKeys.last_visited_place.tr()),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                            right: contentPadding, top: contentPadding),
                        child: InkWell(
                            child: Icon(Icons.close,
                                size: 13, color: colorWhite.withOpacity(0.87)),
                            onTap: () => _bloc.clearCache()),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: state.lLastPlace.isNotEmpty,
                  child: lPlaceWidget(state.lLastPlace),
                ),
                titleWidget(LocaleKeys.the_nearest_place.tr()),
                lPlaceWidget(state.lPlayList)
              ],
            ),
          ),
        ),
      );

  Widget lPlaceWidget(List<PlacesModel> lPlayList) => ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(
            top: 10, left: contentPadding, right: contentPadding),
        itemBuilder: (BuildContext context, int index) => itemPlaces(context,
            lPlayList[index], () => _bloc.placeOnClick(lPlayList[index],context)),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 10),
        itemCount: lPlayList.length,
      );

  Widget changeUiWidget() => Container(
        padding: EdgeInsets.only(bottom: 20.h),
        alignment: Alignment.bottomCenter,
        child: OutlinedButton(
          onPressed: () {
            isShowMap = !isShowMap;
            widget.onCallBackShowMap(isShowMap);
            setState(() {});
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            side: MaterialStateProperty.all(
              const BorderSide(color: Colors.deepOrange, width: 1),
            ),
            fixedSize: MaterialStateProperty.all(
              Size(100.w, 35.h),
            ),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          child: isShowMap
              ? Row(
                  children: [
                    const Icon(
                      Icons.menu,
                      color: Colors.deepOrange,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    AppText(
                      LocaleKeys.list.tr(),
                      style: TextStyle(color: Colors.deepOrange),
                    )
                  ],
                )
              : Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.deepOrange,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    AppText(
                      LocaleKeys.map.tr(),
                      style: TextStyle(color: Colors.deepOrange),
                    )
                  ],
                ),
        ),
      );

  Widget googleMap() => BlocBuilder<PlacesPageCubit, PlacesPageState>(
        bloc: _bloc,
        builder: (BuildContext context, state) {
          if (state.status == FeedStatus.initial ||
              state.status == FeedStatus.refresh) return SizedBox();
          return Visibility(
            visible: isShowMap,
            child: GoogleMap(
              markers: markers,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                try {
                  _controller.complete(controller);
                } catch (ex) {}
              },
            ),
          );
        },
      );

  Widget filterDiaLog() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF212121),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 10.w, right: 20.w, top: 10.h, bottom: 7.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      RouterUtils.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  const AppText(
                    'Removes Filter',
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, color: Colors.white24),
            Padding(
                padding: EdgeInsets.only(
                    left: contentPadding, right: contentPadding, top: 10.h),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5.w),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          customButton: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF212121),
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 1, color: Colors.white60),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.w, right: 10.w),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  AppText(
                                    selectedValue ?? '',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_drop_down_rounded,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                          items: itemCity
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: Container(
                        color: Color(0xFF212121),
                        width: 40.w,
                        height: 15.h,
                        child: Center(
                            child: AppText(
                          LocaleKeys.city.tr(),
                          style: TextStyle(color: Colors.white60),
                        )),
                      ),
                    )
                  ],
                )),
            titleFilter(LocaleKeys.wallHeight.tr(),
                selectedHeight, wallHeight, (index) {
              selectedHeight = index;
              setState(() {});
            }),
            titleFilter(
                LocaleKeys.holdSet.tr(), selectedHold, holdSet,
                (index) {
              selectedHold = index;
              setState(() {});
            }),
            const Divider(
              thickness: 1,
              color: Colors.white24,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h),
              child: MaterialButton(
                color: Colors.deepOrange,
                height: 40.h,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppText(
                      'Show results:',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    const AppText(
                      '25',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget titleFilter(String title, int select, List<String> list,
      Function(int) selectOnClick) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(top: 10.h, left: 15.w, bottom: 10.h),
        child: AppText(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 15),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
        child: lFilterWidget(list, select, (index) {
          selectOnClick(index);
          select = index;
          setState(() {});
        }),
      ),
    ]);
  }

  Widget lFilterWidget(
      List nameList, int select, Function(int) onCallBackSelect) {
    final Size size = MediaQuery.of(context).size;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return SizedBox(
        height: size.height / 18.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: nameList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  onCallBackSelect(index);
                });
              },
              child: Container(
                padding: EdgeInsets.only(left: 17.w, right: 17.w),
                margin: EdgeInsets.only(left: 15.w),
                alignment: Alignment.center,
                decoration: select == index
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.orange, Colors.red],
                        ),
                      )
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white24),
                child: Text(
                  nameList[index],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget itemPlaces(
          BuildContext context, PlacesModel model, VoidCallback itemOnclick) =>
      InkWell(
        child: Container(
          height: 72.h,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.only(left: 25.w),
            child: Row(
              children: [
                SizedBox(
                  height: 49.h,
                  width: 49.h,
                  child: Image.asset(Assets.png.mural.path),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      model.namePlace,
                      style: typoW600.copyWith(
                          fontSize: 20.sp, color: colorText0.withOpacity(0.87)),
                    ),
                    Row(
                      children: [
                        Text(
                          model.nameCity,
                          style: typoW400.copyWith(
                              fontSize: 13.sp,
                              color: colorText0.withOpacity(0.87)),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 5),
                        const Icon(Icons.brightness_1_rounded,
                            color: Colors.white54, size: 8),
                        const SizedBox(width: 5),
                        Text(
                          '${model.distance} km',
                          style: typoW400.copyWith(
                              fontSize: 13.sp,
                              color: colorText0.withOpacity(0.87)),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        onTap: () => itemOnclick.call(),
      );

  @override
  bool get wantKeepAlive => true;
}
