import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/app_text.dart';
import '../../components/filter_widget.dart';
import '../../data/model/routes_model.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF282D2F),
      child: Column(
        children: [
          FilterWidget(
            sortCallBack: () {},
            filterCallBack: () {},
            selectCallBack: () {},
          ),
          Padding(
            padding:  EdgeInsets.only(top: 15.h, left: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const AppText(
                'THE NEAREST PLACES',
                style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 100.h,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return index == nearestPlace.length
                          ?
                      box('More', Colors.black,icon: Icons.search)
                          : box(nearestPlace[index],Colors.blue);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                          width: 30.w,
                        ),
                    itemCount: nearestPlace.length + 1),
              ),
              const AppText(
                'TOP ROUTES BY GRADE',
                style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
              ),
                Padding(
                  padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                  child: SizedBox(
                    height: 60.h,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return ItemTopRoute(
                            lRouteSearch[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                              width: 10.h,
                            ),
                        itemCount: lRouteSearch.length),
                  ),
                ),
                AppText(
                  'TOP ROUTE SETTERS',
                  style:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 100.h,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return index == routeSetter.length
                            ?
                        box('More', Colors.black,icon: Icons.search)
                            :box(routeSetter[index],Colors.yellow);
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                            width: 30.w,
                          ),
                      itemCount: routeSetter.length + 1),
                ),
            ],),
          ),
        ],
      ),
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

Widget ItemTopRoute(RoutesModel model) {
  return Container(
    width: 60.w,
    decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: getBackgroundColor(model.grade),
        ),
        borderRadius: BorderRadius.circular(100)),
    child: Center(
        child: AppText(
           model.grade,
          style: TextStyle(
              color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 20),
        )),
  );
}
