import 'dart:async';

import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_button.dart';
import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/modules/find_place/find_place_cubit.dart';
import 'package:base_bloc/modules/find_place/find_place_state.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../../components/app_text.dart';
import '../../components/app_text_field.dart';
import '../../components/appbar_widget.dart';
import '../../data/model/places_model.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_styles.dart';
import '../../theme/colors.dart';

class FindPlacePage extends StatefulWidget {
  const FindPlacePage({Key? key}) : super(key: key);

  @override
  State<FindPlacePage> createState() => _FindPlacePageState();
}

class _FindPlacePageState extends BasePopState<FindPlacePage> {
  var isShowMap = true;
  final searchOnChange = BehaviorSubject<String>();
  Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _kGooglePlex;
  final Set<Marker> markers = new Set();
  late FindPlaceCubit _bloc;

  @override
  void initState() {
    _bloc = FindPlaceCubit();
    listenSearch();
    super.initState();
  }

  void listenSearch() => searchOnChange
      .debounceTime(const Duration(seconds: 1))
      .listen((query) => _bloc.search(query));

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
        appbar: appbar(context),
        isTabToHideKeyBoard: true,
        backgroundColor: colorBackgroundColor,
        body: Stack(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                itemSpace(),
                Center(
                  child: filterWidget(context),
                ),
                itemSpace(height: 15),
                Expanded(
                    child: BlocBuilder<FindPlaceCubit, FindPlaceState>(
                  bloc: _bloc,
                  builder: (c, state) {
                    if (state.status == FindPlaceStatus.success) {
                      initMarker(state);
                    }
                    if (state.status == FindPlaceStatus.initial ||
                        state.status == FindPlaceStatus.search) {
                      return const Center(
                        child: AppCircleLoading(),
                      );
                    } else if (state.status == FindPlaceStatus.success) {
                      if (state.isShowMap) {
                        return googleMapWidget(context);
                      }
                      return lPlaceWidget(context, state);
                    }
                    return const SizedBox();
                  },
                )),
              ],
            ),
          ),
          BlocBuilder<FindPlaceCubit, FindPlaceState>(
            builder: (c, state) =>
                switchButton(callback: () => _bloc.showMap(), state: state),
            bloc: _bloc,
          ),
        ]));
  }

  void initMarker(FindPlaceState state) {
    _kGooglePlex = CameraPosition(
        target: LatLng(state.lPlayList[0].lat, state.lPlayList[0].lng),
        zoom: 15);
    for (int i = 0; i < state.lPlayList.length; i++) {
      markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(state.lPlayList[i].lat, state.lPlayList[i].lng)));
    }
  }

  Widget googleMapWidget(BuildContext context) => Visibility(
      visible: true,
      child: GoogleMap(
        markers: markers,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        initialCameraPosition: _kGooglePlex,
        onTap: (lng) => _bloc.mapCallback(lng, context),
        onMapCreated: (GoogleMapController controller) {
          try {
            _controller.complete(controller);
          } catch (ex) {}
        },
      ));

  Widget switchButton(
          {required VoidCallback callback, required FindPlaceState state}) =>
      Positioned.fill(
          child: Align(
        alignment: Alignment.bottomCenter,
        child: AppButton(
            height: 36/*30.h*/,
            padding: const EdgeInsets.only(left: 10, right: 10),
            backgroundColor: colorWhite,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(color: colorOrange100)),
            onPress: () => callback.call(),
            titleWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  !state.isShowMap ? Icons.location_on : Icons.list,
                  color: colorOrange100,
                ),
                const SizedBox(
                  width: 5,
                ),
                AppText(
                  !state.isShowMap ? LocaleKeys.map.tr() : LocaleKeys.list.tr(),
                  style: typoSmallTextRegular.copyWith(color: colorOrange100),
                )
              ],
            )),
      ));

  Widget itemSpace({double height = 10}) => SizedBox(
        height: height,
      );

  Widget filterWidget(BuildContext context) => InkWell(
        onTap: () => Utils.showActionDialog(context, (p0) {}),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.filter_alt_outlined,
              color: colorWhite,
              size: 20,
            ),
            const SizedBox(
              width: 2,
            ),
            AppText(
              LocaleKeys.filter.tr(),
              style: typoW400.copyWith(fontSize: 13.sp),
            )
          ],
        ),
      );

  PreferredSizeWidget appbar(BuildContext context) => appBarWidget(
      backgroundColor: colorBackgroundColor,
      context: context,
      titleSpacing: 0,
      leadingWidth: 40.w,
      toolbarHeight: 50.h,
      title: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 100),
        child: AppTextField(
          onChanged: (text) => searchOnChange.add(text),
          isShowErrorText: false,
          textStyle: typoSmallTextRegular.copyWith(
            color: colorText0,
          ),
          cursorColor: Colors.white60,
          decoration: decorTextField.copyWith(
              prefixIcon: const Icon(
                Icons.search,
                color: colorText45,
              ),
              hintStyle: typoW400.copyWith(
                  fontSize: 14.5.sp, color: colorText0.withOpacity(0.6)),
              hintText: LocaleKeys.find_place.tr(),
              contentPadding: EdgeInsets.all(15.h),
              fillColor: colorBlack10,
              border: border,
              enabledBorder: border,
              focusedBorder: border),
        ),
      ));
  var border = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.all(Radius.circular(50)),
  );

  Widget line() => const Divider(
        thickness: 1,
        color: Colors.white24,
      );

  Widget lPlaceWidget(BuildContext context, FindPlaceState state) =>
      ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (BuildContext context, int index) {
          return itemPlaces(context, state.lPlayList[index]);
        },
        separatorBuilder: (BuildContext context, int index) => SizedBox(
          height: 10.h,
        ),
        itemCount: state.lPlayList.length,
      );

  Widget itemPlaces(BuildContext context, PlacesModel model) {
    return InkWell(
      child: Container(
        height: 72.h,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.only(left: 25.w),
          child: Row(
            children: [
              Container(
                height: 56.w,
                width: 56.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.yellow),
              ),
              SizedBox(
                width: 20.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.namePlace,
                    style: typoW600.copyWith(
                        fontSize: 20.sp, color: colorText0.withOpacity(0.87)),
                  ),
                  Row(
                    children: [
                      AppText(
                        model.nameCity,
                        style: typoW400.copyWith(
                            fontSize: 13.sp,
                            color: colorText0.withOpacity(0.6)),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      const Icon(
                        Icons.brightness_1_rounded,
                        color: Colors.white54,
                        size: 8,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      AppText(
                        "${model.distance}km",
                        style: typoW400.copyWith(
                            fontSize: 13.sp,
                            color: colorText0.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () => _bloc.itemOnclick(model, context),
    );
  }

  @override
  int get tabIndex => BottomNavigationConstant.TAB_RESERVATIONS;
}
