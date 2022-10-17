import 'dart:async';
import 'package:base_bloc/components/filter_widget.dart';
import 'package:base_bloc/data/model/list_places_model.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/places_page/places_page_cubit.dart';
import 'package:base_bloc/modules/places_page/places_page_state.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../components/app_text.dart';
import '../../data/eventbus/hide_map_event.dart';
import '../../data/eventbus/search_home_event.dart';
import '../../theme/app_styles.dart';
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

class _PlacesPageState extends State<PlacesPage> {
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
    // final Size size = MediaQuery.of(context).size;
    return Container(
        color: colorGreyBackground,
        child: Center(
            child: AppText('This feature is under construction',
                style: googleFont.copyWith(color: colorWhite))));
    // BlocBuilder<PlacesPageCubit, PlacesPageState>(
    //   bloc: _bloc,
    //   builder: (c, state) {
    //     if (state.status == FeedStatus.success) {
    //       _kGooglePlex = CameraPosition(
    //           target: LatLng(state.lPlayList[0].lat, state.lPlayList[0].lng),
    //           zoom: 15);
    //       for (int i = 0; i < state.lPlayList.length; i++) {
    //         markers.add(Marker(
    //             markerId: MarkerId(i.toString()),
    //             position:
    //                 LatLng(state.lPlayList[i].lat, state.lPlayList[i].lng)));
    //       }
    //     }
    //     return Container(
    //       color: const Color(0xFF282D2F),
    //       child: Column(
    //         children: [
    //           FilterWidget(
    //               sortCallBack: () {},
    //               filterCallBack: () {
    //                 showModalBottomSheet<void>(
    //                   context: context,
    //                   backgroundColor: Colors.transparent,
    //                   builder: (BuildContext context) {
    //                     return filterDiaLog();
    //                   },
    //                 );
    //               },
    //               selectCallBack: () {},
    //               isSelect: false),
    //           Expanded(
    //             child: Stack(
    //               children: [
    //                 BlocBuilder<PlacesPageCubit, PlacesPageState>(
    //                   bloc: _bloc,
    //                   builder: (BuildContext context, state) {
    //                     if (state.status == FeedStatus.initial ||
    //                         state.status == FeedStatus.refresh)
    //                       return SizedBox();
    //                     return Visibility(
    //                       visible: isShowMap,
    //                       child: GoogleMap(
    //                         markers: markers,
    //                         zoomControlsEnabled: true,
    //                         zoomGesturesEnabled: true,
    //                         scrollGesturesEnabled: true,
    //                         initialCameraPosition: _kGooglePlex,
    //                         onMapCreated: (GoogleMapController controller) {
    //                           try {
    //                             _controller.complete(controller);
    //                           } catch (ex) {}
    //                         },
    //                       ),
    //                     );
    //                   },
    //                 ),
    //                 BlocBuilder<PlacesPageCubit, PlacesPageState>(
    //                   bloc: _bloc,
    //                   builder: (BuildContext context, state) => Visibility(
    //                     visible: !isShowMap,
    //                     child: Container(
    //                       height: size.height,
    //                       color: const Color(0xFF3B4244),
    //                       child: ListView.separated(
    //                         shrinkWrap: true,
    //                         padding: const EdgeInsets.only(top: 10),
    //                         itemBuilder: (BuildContext context, int index) {
    //                           return itemPlaces(
    //                               context, state.lPlayList[index]);
    //                         },
    //                         separatorBuilder:
    //                             (BuildContext context, int index) => SizedBox(
    //                           height: 10.h,
    //                         ),
    //                         itemCount: state.lPlayList.length,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(bottom: 20.h),
    //                   alignment: Alignment.bottomCenter,
    //                   child: OutlinedButton(
    //                     onPressed: () {
    //                       isShowMap = !isShowMap;
    //                       widget.onCallBackShowMap(isShowMap);
    //                       setState(() {});
    //                     },
    //                     style: ButtonStyle(
    //                       overlayColor:
    //                           MaterialStateProperty.all(Colors.transparent),
    //                       splashFactory: NoSplash.splashFactory,
    //                       side: MaterialStateProperty.all(
    //                         const BorderSide(
    //                             color: Colors.deepOrange, width: 1),
    //                       ),
    //                       fixedSize: MaterialStateProperty.all(
    //                         Size(100.w, 35.h),
    //                       ),
    //                       backgroundColor:
    //                           MaterialStateProperty.all(Colors.white),
    //                       shape: MaterialStateProperty.all(
    //                         RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(40),
    //                         ),
    //                       ),
    //                     ),
    //                     child: isShowMap
    //                         ? Row(
    //                             children: [
    //                               const Icon(
    //                                 Icons.menu,
    //                                 color: Colors.deepOrange,
    //                               ),
    //                               SizedBox(
    //                                 width: 10.w,
    //                               ),
    //                               AppText(
    //                                 AppLocalizations.of(context)!.list,
    //                                 style:
    //                                     TextStyle(color: Colors.deepOrange),
    //                               )
    //                             ],
    //                           )
    //                         : Row(
    //                             children: [
    //                               const Icon(
    //                                 Icons.location_on,
    //                                 color: Colors.deepOrange,
    //                               ),
    //                               SizedBox(
    //                                 width: 5.w,
    //                               ),
    //                               AppText(
    //                                 AppLocalizations.of(context)!.map,
    //                                 style:
    //                                     TextStyle(color: Colors.deepOrange),
    //                               )
    //                             ],
    //                           ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //   });
  }

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
            const Divider(
              thickness: 1,
              color: Colors.white24,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.w),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        customButton: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Color(0xFF212121),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.white60),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                AppText(
                                  selectedValue ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        isExpanded: true,
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
                        AppLocalizations.of(context)!.city,
                        style: TextStyle(color: Colors.white60),
                      )),
                    ),
                  )
                ],
              ),
            ),
            titleFilter(AppLocalizations.of(context)!.wallHeight, selectedHeight, wallHeight, (index) {
              selectedHeight = index;
              setState(() {});
            }),
            titleFilter(AppLocalizations.of(context)!.holdSet, selectedHold, holdSet, (index) {
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
        child: ListFilterDialog(list, select, (index) {
          selectOnClick(index);
          select = index;
          setState(() {});
        }),
      ),
    ]);
  }

  Widget ListFilterDialog(
      List nameList, int select, Function(int) onCallBackSelect) {
    final Size size = MediaQuery.of(context).size;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
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

  Widget itemPlaces(BuildContext context, PlacesModel model) {
    final Size size = MediaQuery.of(context).size;
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
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 17),
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
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 17),
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
}
