import 'dart:async';

import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/data/model/places_model.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../components/app_text.dart';
import '../../../data/globals.dart';
import '../../../localization/locale_keys.dart';
import '../../../utils/app_utils.dart';
import 'address_cubit.dart';

class Address extends StatefulWidget {
  final PlacesModel model;
  final int index;

  const Address({Key? key, required this.model, required this.index}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  late AddressCubit _bloc;
  final Set<Marker> markers = new Set();
  late CameraPosition _kGooglePlex;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    _bloc = AddressCubit(widget.index);
    _kGooglePlex = CameraPosition(
        target: LatLng(
      widget.model.lat, widget.model.lng),
        zoom: 15);
    markers.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(
            widget.model.lat, widget.model.lng)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorGreyBackground,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 70.h,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    SizedBox(
                      width: contentPadding,
                    ),
                    const Icon(
                      Icons.location_on,
                      color: colorGrey60,
                    ),
                    SizedBox(
                      width: contentPadding,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          widget.model.namePlace,
                          style: googleFont.copyWith(
                              color: colorGrey60, fontSize: 15.sp),
                        ),
                        AppText(
                          widget.model.nameCity,
                          style: googleFont.copyWith(
                              color: colorGrey60, fontSize: 15.sp),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(child: googleMap())
            ],
          ),
          addWidget(context)
        ],
      ),
    );
  }

  Widget addWidget(BuildContext context) => Positioned.fill(
        bottom: 10.h,
        right: 10.h,
        child: Align(
          alignment: Alignment.bottomRight,
          child: InkWell(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: Utils.backgroundGradientOrangeButton()),
              width: MediaQuery.of(context).size.width / 2.8,
              height: 37.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add,
                    color: colorWhite,
                    size: 18,
                  ),
                  AppText(
                    " ${LocaleKeys.notification.tr()}",
                    style:
                        typoW600.copyWith(color: colorText0, fontSize: 13.sp),
                  )
                ],
              ),
            ),
            onTap: () => _bloc.addOnclick(context),
          ),
        ),
      );

  Widget googleMap() => BlocBuilder(
    bloc: _bloc,
    builder: (BuildContext context, state) {
        return  GoogleMap(
          markers: markers,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            try {
              _controller.complete(controller);
            } catch (ex) {}
          },
      );
    },
  );
}
