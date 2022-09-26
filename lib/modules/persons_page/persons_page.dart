import 'dart:async';
import 'package:base_bloc/data/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/app_text.dart';
import '../../components/filter_widget.dart';
import '../../data/eventbus/search_home_event.dart';
import '../../data/model/person_model.dart';
import '../../theme/colors.dart';
import '../../utils/app_utils.dart';

class PersonsPage extends StatefulWidget {
  final int index;

  const PersonsPage({Key? key, required this.index}) : super(key: key);

  @override
  State<PersonsPage> createState() => _PersonsPageState();
}

var lPerson = [
  PersonModel('assets/images/1.png', 'Adam Kowalski', 'Route setter'),
  PersonModel('assets/images/2.png', 'Zoe Smith', 'Route setter'),
];

class _PersonsPageState extends State<PersonsPage> {
  String? keySearch = '';

  StreamSubscription<SearchHomeEvent>? _searchEvent;

  @override
  void initState() {
    _searchEvent = Utils.eventBus.on<SearchHomeEvent>().listen((event) {
      if (event.index == widget.index) {
        keySearch = event.key;
        if (mounted) setState(() {});
        print("TAG person");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      color: colorGrey50,
      child: Column(
        children: [
          FilterWidget(
              sortCallBack: () {},
              filterCallBack: () {},
              selectCallBack: () {}),
          Container(
            color: const Color(0xFF3B4244),
            child: keySearch!.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.all(12),
                    itemBuilder: (BuildContext context, int index) {
                      return itemPerson(lPerson[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                          height: 10.h,
                        ),
                    itemCount: lPerson.length)
                : SingleChildScrollView(
                    child: Container(
                      color: Color(0xFF3B4244),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.h, left: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText(
                              'FRIENDS',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(12),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return box();
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                  itemCount: 3),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, right: 10.w, bottom: 10.h),
                                child: Container(
                                  height: size.height / 17,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: const Center(
                                    child: AppText(
                                      'See all',
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const AppText(
                              'TOP ROUTE SETTER',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500),
                            ),
                            ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(12),
                                itemBuilder: (BuildContext context, int index) {
                                  return box();
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                itemCount: 3),
                            InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, right: 10.w, bottom: 10.h),
                                child: Container(
                                  height: size.height / 17,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: const Center(
                                    child: AppText(
                                      'See all',
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Widget itemPerson(PersonModel model) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 8,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 30.w),
            child: Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(100)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                model.nickName,
                style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: 25),
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                children: [
                  AppText(
                    model.typeUser,
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  const Icon(
                    Icons.circle_sharp,
                    color: Colors.white70,
                    size: 7,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget box() {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 10,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 30.w),
            child: Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(100)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                'Adam Kowalski',
                style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: 25),
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                children: [
                  const AppText(
                    "Route setter",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  const Icon(
                    Icons.circle_sharp,
                    color: Colors.white70,
                    size: 7,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
