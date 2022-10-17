import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/all_page/all_page_cubit.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/app_text.dart';
import '../../data/model/routes_model.dart';
import '../../utils/app_utils.dart';

class AllPage extends StatefulWidget {
  const AllPage({Key? key}) : super(key: key);

  @override
  State<AllPage> createState() => _AllPageState();
}

var nearestPlace = ['Murall', 'Malak', 'Obiekto'];

var routeSetter = [
  'Adam saasd',
  'ajsdhkahskdh',
  'asdskdkssfksd',
];


class _AllPageState extends State<AllPage> {
  late final AllPageCubit _bloc;

  @override
  void initState() {
    _bloc = AllPageCubit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorGreyBackground,
      child: Center(child: AppText('This feature is under construction',style: googleFont.copyWith(color: colorWhite),))
      // Column(
      //   children: [
      //     Padding(
      //       padding: EdgeInsets.only(top: 15.h, left: 15.w),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //            AppText(
      //             LocaleKeys.theNearest,
      //             style: typoLargeTextBold.copyWith(color: colorGrey60,fontSize: 12.sp)
      //           ),
      //           SizedBox(
      //             height: 10.h,
      //           ),
      //           SizedBox(
      //             height: 100.h,
      //             child: ListView.separated(
      //                 scrollDirection: Axis.horizontal,
      //                 itemBuilder: (BuildContext context, int index) {
      //                   return index == nearestPlace.length
      //                       ? box('More', Colors.black, icon: Icons.search)
      //                       : box(nearestPlace[index], Colors.blue);
      //                 },
      //                 separatorBuilder: (BuildContext context, int index) =>
      //                     SizedBox(
      //                       width: 30.w,
      //                     ),
      //                 itemCount: nearestPlace.length + 1),
      //           ),
      //           const AppText(
      //             'TOP ROUTES BY GRADE',
      //             style: TextStyle(
      //                 color: Colors.white70, fontWeight: FontWeight.w500),
      //           ),
      //           Padding(
      //             padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
      //             child: SizedBox(
      //               height: 60.h,
      //               child: ListView.separated(
      //                   scrollDirection: Axis.horizontal,
      //                   itemBuilder: (BuildContext context, int index) {
      //                     return itemTopRoute(
      //                       _bloc.fakeData()[index],
      //                     );
      //                   },
      //                   separatorBuilder: (BuildContext context, int index) =>
      //                       SizedBox(
      //                         width: 10.h,
      //                       ),
      //                   itemCount: _bloc.fakeData().length),
      //             ),
      //           ),
      //           const AppText(
      //             'TOP ROUTE SETTERS',
      //             style: TextStyle(
      //                 color: Colors.white70, fontWeight: FontWeight.w500),
      //           ),
      //           SizedBox(
      //             height: 10.h,
      //           ),
      //           SizedBox(
      //             height: 100.h,
      //             child: ListView.separated(
      //                 scrollDirection: Axis.horizontal,
      //                 itemBuilder: (BuildContext context, int index) {
      //                   return index == routeSetter.length
      //                       ? box('More', Colors.black, icon: Icons.search)
      //                       : box(routeSetter[index], Colors.yellow);
      //                 },
      //                 separatorBuilder: (BuildContext context, int index) =>
      //                     SizedBox(
      //                       width: 30.w,
      //                     ),
      //                 itemCount: routeSetter.length + 1),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget box(String text, Color? color, {IconData? icon}) {
    return SizedBox(
      width: 60.w,
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(100)),
            child: Icon(
              icon,
              color: Colors.white,
              size: 35,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          AppText(
            text,
            maxLine: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70),
          )
        ],
      ),
    );
  }
}

Widget itemTopRoute(RoutesModel model) {
  return Container(
    width: 60.w,
    decoration: BoxDecoration(
        gradient:   LinearGradient(
    colors: Utils.getBackgroundColor(model.grade)),
        borderRadius: BorderRadius.circular(100)),
    child: Center(
      child: AppText(
        model.grade,
        style: const TextStyle(
            color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 20),
      ),
    ),
  );
}
