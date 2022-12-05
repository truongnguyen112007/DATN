import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/modules/search/search_page_cubit.dart';
import 'package:base_bloc/modules/search/search_page_state.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import '../../components/app_scalford.dart';
import '../../data/eventbus/search_home_event.dart';
import '../../data/globals.dart';
import '../../gen/assets.gen.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_styles.dart';
import '../../utils/app_utils.dart';
import '../all_page/all_page.dart';
import '../persons_page/persons_page.dart';
import '../places_page/place_page.dart';
import '../routes_page/routes_page.dart';

class SearchPage extends StatefulWidget {
  final int index;

  const SearchPage({Key? key, required this.index}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends BasePopState<SearchPage>
    with TickerProviderStateMixin {
  var isShowMap = false;

  int selectedIndex = SearchConstant.ROUTE;

  late SearchCubit _bloc;

  final itemOnChange = BehaviorSubject<String>();

  TextEditingController? textEditingController;

  late PageController pageController;

  void _jumpToPage(int index) {
    selectedIndex = index;
    pageController.jumpToPage(selectedIndex);
    _bloc.jumToPage(selectedIndex);
  }

  @override
  void initState() {
    pageController = PageController(initialPage: BottomNavigationSearch.TAB_ROUTES);
    pageController.addListener(() {
      var newPage = pageController.page!.round();
      _bloc.jumToPage(newPage);
    });
    textEditingController = TextEditingController();

    itemOnChange
        .debounceTime(const Duration(seconds: 1))
        .listen((value){
          logE("sdlfkjsd");
      Utils.fireEvent(
        SearchHomeEvent(selectedIndex, value),
      );
    });

    _bloc = SearchCubit();

    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    textEditingController?.dispose();
    itemOnChange.close();
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorBlack,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              appBar(),
              SizedBox(
                height: 10.h,
              ),
              categoryWidget(),
              SizedBox(
                height: 8.h,
              ),
              const Divider(thickness: 1, color: colorGrey80, height: 2),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: [
                    const AllPage(),
                    PlacesPage(
                      root: widget.index,
                      index: SearchConstant.PLACE,
                      onCallBackShowMap: (i) {},
                    ),
                    const RoutesPage(index: SearchConstant.ROUTE),
                    const PersonsPage(index: SearchConstant.PERSONS),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  int get tabIndex => widget.index;

  void clearText() {
    Utils.fireEvent(
      SearchHomeEvent(selectedIndex, ''),
    );
    textEditingController?.text = '';
    setState(() {});
  }

  Widget appBar() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          right: contentPadding,
          left: contentPadding),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                Assets.svg.backButton,
                color: colorWhite.withOpacity(1.0),
                width: 16.sp,
              )),
          SizedBox(
            width: 20.w,
          ),
          Expanded(
            child: TextField(
              style: const TextStyle(color: colorWhite),
              onChanged: (str){
                itemOnChange.add(str);
              },
              controller: textEditingController,
              autofocus: true,
              cursorColor: colorOrange40,
              cursorHeight: 24.h,
              decoration: InputDecoration(
                hintText: LocaleKeys.hinTextSearchHome.tr(),
                hintStyle:
                    googleFont.copyWith(fontSize: 16.sp,fontWeight:FontWeight.w400,color: colorSubText),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: colorTransparent),
                  borderRadius: BorderRadius.circular(28),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: colorTransparent),
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                contentPadding: EdgeInsets.only(left: 20.w),
                fillColor: colorGrey85,
                prefixIconConstraints: BoxConstraints(maxWidth: 60.w),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 14.w,right: contentPadding),
                  child: SvgPicture.asset(
                    Assets.svg.searchIcon, color: HexColor('#FFFFFF').withOpacity(0.87),
                  ),
                ),
                suffixIconConstraints: BoxConstraints(maxWidth: 35.w),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: contentPadding),
                  child: InkWell(
                    onTap: () {
                      clearText();
                    },
                    child: SvgPicture.asset(Assets.svg.closeIcon,color: HexColor('#FFFFFF').withOpacity(0.87),)
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryWidget() {
    final List<String> search = [
      LocaleKeys.all.tr(),
      LocaleKeys.places.tr(),
      LocaleKeys.routes.tr(),
      LocaleKeys.persons.tr()
    ];

    return SizedBox(
      height: 32.h,
      child: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, state) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: search.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _jumpToPage(index);
              },
              child: Container(
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                margin: EdgeInsets.only(left: 6.w),
                alignment: Alignment.center,
                decoration: (state is InitSearchState && index == BottomNavigationSearch.TAB_ROUTES) ||
                        (state is ChangeTabState && state.index == index)
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient:
                        Utils.backgroundGradientOrangeButton()
                      )
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colorGreyBackground),
                child: Text(
                  search[index],
                  style: const TextStyle(color: colorWhite),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
