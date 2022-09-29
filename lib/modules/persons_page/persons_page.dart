import 'dart:async';
import 'package:base_bloc/modules/persons_page/persons_page_cubit.dart';
import 'package:base_bloc/modules/persons_page/persons_page_state.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/app_circle_loading.dart';
import '../../components/app_text.dart';
import '../../components/filter_widget.dart';
import '../../data/eventbus/search_home_event.dart';
import '../../data/globals.dart';
import '../../data/model/person_model.dart';
import '../../localizations/app_localazations.dart';
import '../../router/router_utils.dart';
import '../../theme/app_styles.dart';
import '../../theme/colors.dart';
import '../../utils/app_utils.dart';

class PersonsPage extends StatefulWidget {
  final int index;

  const PersonsPage({Key? key, required this.index}) : super(key: key);

  @override
  State<PersonsPage> createState() => _PersonsPageState();
}

final List<String> type = ["Climber", "Trainer", "Route setter", "Pro"];

final List<String> profile = ["Official", "Standard"];

class _PersonsPageState extends State<PersonsPage>
    with AutomaticKeepAliveClientMixin {
  String? keySearch = '';
  int selectedType = 0;
  int selectedProfile = 0;
  final _scrollController = ScrollController();
  late final PersonsPageCubit _bloc;
  StreamSubscription<SearchHomeEvent>? _searchEvent;

  @override
  void initState() {
    _searchEvent = Utils.eventBus.on<SearchHomeEvent>().listen(
      (event) {
        if (event.index == widget.index) {
          keySearch = event.key;
          _bloc.search(keySearch!);
          print("TAG person");
        }
      },
    );
    _bloc = PersonsPageCubit();
    paging();
    super.initState();
  }

  void paging() {
    if (_scrollController.hasClients) {
      _scrollController.addListener(() {
        if (!_scrollController.hasClients) return;
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;
        if (currentScroll >= (maxScroll * 0.9)) _bloc.getFeed(isPaging: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorGrey50,
      child: Column(
        children: [
          FilterWidget(
              sortCallBack: () {},
              filterCallBack: () {
                showActionDialog();
              },
              selectCallBack: () {}),
          Expanded(
            child: Container(
              color: const Color(0xFF3B4244),
              child: RefreshIndicator(
                onRefresh: () async => _bloc.refresh(),
                child: Stack(
                  children: [
                    BlocBuilder<PersonsPageCubit, PersonsPageState>(
                        bloc: _bloc,
                        builder: (BuildContext context, state) {
                          Widget? widget;
                          if (state.status == StatusType.initial ||
                              state.status == StatusType.refresh) {
                            widget = const SizedBox();
                          } else if (state.status == StatusType.success) {
                            widget = SingleChildScrollView(
                              child: Container(
                                color: const Color(0xFF3B4244),
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.h, left: 5.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      heading(
                                        AppLocalizations.of(context)!.friend,
                                      ),
                                      lPersonsWidget(state.lFriend),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      buttonSeeAll(),
                                      heading(AppLocalizations.of(context)!
                                          .topRouteSetter),
                                      lPersonsWidget(state.lTopRouteSetter),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      buttonSeeAll(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else if (state.status == StatusType.search) {
                            widget = Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: lPersonsWidget(state.lTopRouteSetter));
                          }
                          return widget!;
                        }),
                    BlocBuilder<PersonsPageCubit, PersonsPageState>(
                      bloc: _bloc,
                      builder: (BuildContext context, state) =>
                          (state.status == StatusType.initial ||
                                  state.status == StatusType.refresh)
                              ? const Center(
                                  child: AppCircleLoading(),
                                )
                              : const SizedBox(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget heading(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: AppText(title,
          style: typoExtraSmallTextRegular.copyWith(
              fontSize: 15, fontWeight: FontWeight.w500, color: colorGrey50)),
    );
  }

  Widget buttonSeeAll() {
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
        child: Container(
          height: size.height / 17,
          decoration: BoxDecoration(
              color: colorBlack, borderRadius: BorderRadius.circular(20)),
          child: Center(
              child: AppText(
            AppLocalizations.of(context)!.seeAll,
            style:
                typoLargeTextRegular.copyWith(color: colorRed70, fontSize: 15),
          )),
        ),
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

  Widget lPersonsWidget(List<PersonModel> list) {
    return ListView.separated(
      padding: EdgeInsets.only(left: contentPadding, right: contentPadding),
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      itemBuilder: (BuildContext context, int index) => (index == list.length)
          ? const Center(child: AppCircleLoading())
          : itemPerson(list[index]),
      itemCount: list.length,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 10,
      ),
    );
  }

  void showActionDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (x) => Wrap(
        children: [
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF212121),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF212121),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
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
                    titleFilter('Type', selectedType, type, (index) {
                      selectedType = index;
                      setState(() {});
                    }),
                    titleFilter('Profile', selectedProfile, profile, (index) {
                      selectedProfile = index;
                      setState(() {});
                    }),
                    const Divider(
                      thickness: 1,
                      color: Colors.white24,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h),
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
                    SizedBox(
                      height: 15.h,
                    )
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget titleFilter(String title, int select, List<String> list,
      Function(int) selectOnClick) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, left: 15.w, bottom: 10.h),
          child: AppText(
            title,
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: listFilterDialog(type, select, (index) {
            select = index;
            setState(() {});
          }),
        ),
      ],
    );
  }

  Widget listFilterDialog(
      List nameList, int select, Function(int) onCallBackSelect) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 20.h,
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
              padding: EdgeInsets.only(left: 15.w, right: 15.w),
              margin: EdgeInsets.only(left: 5.w),
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
  }

  @override
  bool get wantKeepAlive => true;
}
