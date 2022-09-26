import 'dart:async';
import 'package:base_bloc/components/filter_widget.dart';
import 'package:base_bloc/data/model/list_places_model.dart';
import 'package:base_bloc/modules/places_page/places_page_cubit.dart';
import 'package:base_bloc/modules/places_page/places_page_state.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../components/app_text.dart';
import '../../data/eventbus/hide_map_event.dart';
import '../../data/eventbus/search_home_event.dart';
import '../../theme/colors.dart';
import '../../utils/app_utils.dart';

class PlacesPage extends StatefulWidget {
  final int index;
  final Function(bool isShow) onCallBackShowMap;

  const PlacesPage(
      {Key? key, required this.index, required this.onCallBackShowMap})
      : super(key: key);

  @override
  State<PlacesPage> createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  bool isShowMap = false;
  Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _kGooglePlex;
  final Set<Marker> markers = new Set();
  StreamSubscription<HideMapEvent>? _hideMapStream;
  StreamSubscription<SearchHomeEvent>? _searchStream;

  late PlacesPageCubit _bloc;

  @override
  void initState() {
    _bloc = PlacesPageCubit();
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
    final Size size = MediaQuery
        .of(context)
        .size;
    return BlocBuilder<PlacesPageCubit, PlacesPageState>(
        bloc: _bloc,
        builder: (c, state) {
          if (state.status == FeedStatus.success) {
            _kGooglePlex = CameraPosition(
                target: LatLng(state.lPlayList[0].lat, state.lPlayList[0].lng),
                zoom: 15);
            for (int i = 0; i < state.lPlayList.length; i++) {
              markers.add(Marker(
                  markerId: MarkerId(i.toString()),
                  position:
                  LatLng(state.lPlayList[i].lat, state.lPlayList[i].lng)));
            }
          }
          return Container(
            color: const Color(0xFF282D2F),
            child: Column(
              children: [
                FilterWidget(
                    sortCallBack: () {},
                    filterCallBack: () {},
                    selectCallBack: () {}),
                Expanded(
                  child: Stack(
                    children: [
                      BlocBuilder<PlacesPageCubit, PlacesPageState>(
                        bloc: _bloc,
                        builder: (BuildContext context, state) {
                          if (state.status == FeedStatus.initial || state.status
                              == FeedStatus.refresh)
                            return SizedBox();
                          return
                            Visibility(
                              visible: isShowMap,
                              child: GoogleMap(
                                markers: markers,
                                zoomControlsEnabled: true,
                                zoomGesturesEnabled: true,
                                scrollGesturesEnabled: true,
                                initialCameraPosition:_kGooglePlex,
                                onMapCreated: (GoogleMapController controller) {
                                  try {
                                    _controller.complete(controller);
                                  } catch (ex) {}
                                },
                              ),
                            );
                        },
                      ),
                      BlocBuilder<PlacesPageCubit, PlacesPageState>(
                        bloc: _bloc,
                        builder: (BuildContext context, state) =>
                            Visibility(
                              visible: !isShowMap,
                              child: Container(
                                height: size.height,
                                color: const Color(0xFF3B4244),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(top: 10),
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return itemPlaces(
                                        context, state.lPlayList[index]);
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                  itemCount: state.lPlayList.length,
                                ),
                              ),
                            ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 20.h),
                        alignment: Alignment.bottomCenter,
                        child: OutlinedButton(
                          onPressed: () {
                            isShowMap = !isShowMap;
                            widget.onCallBackShowMap(isShowMap);
                            setState(() {});
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.transparent),
                            splashFactory: NoSplash.splashFactory,
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                  color: Colors.deepOrange, width: 1),
                            ),
                            fixedSize: MaterialStateProperty.all(
                              Size(100.w, 35.h),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white),
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
                              const AppText(
                                'List',
                                style: TextStyle(color: Colors.deepOrange),
                              )
                            ],
                          ) : Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.deepOrange,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              const AppText(
                                'Map',
                                style: TextStyle(color: Colors.deepOrange),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

Widget itemPlaces(BuildContext context, PlacesModel model) {
  final Size size = MediaQuery
      .of(context)
      .size;
  return Padding(
    padding: EdgeInsets.only(left: 10.w, right: 20.w),
    child: Container(
      height: size.height / 8,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.only(left: 25.w),
        child: Row(
          children: [
            Container(
              height: 55.h,
              width: 55.h,
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
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
                Row(
                  children: [
                    Text(
                      model.nameCity,
                      style:
                      const TextStyle(color: Colors.white54, fontSize: 17),
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
                    Text(
                      model.distance.toString(),
                      style:
                      const TextStyle(color: Colors.white54, fontSize: 17),
                    ),
                    const AppText(
                      'km',
                      style: TextStyle(color: Colors.white54, fontSize: 17),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
