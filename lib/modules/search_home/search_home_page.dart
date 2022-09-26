import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/search_home/search_home_cubit.dart';
import 'package:base_bloc/modules/search_home/search_home_state.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import '../../components/app_scalford.dart';
import '../../data/eventbus/search_home_event.dart';
import '../../theme/app_styles.dart';
import '../../utils/app_utils.dart';
import '../all_page/all_page.dart';
import '../persons_page/persons_page.dart';
import '../places_page/place_page.dart';
import '../routes_page/routes_page.dart';

class SearchHomePage extends StatefulWidget {
  final int index;

  const SearchHomePage({Key? key, required this.index}) : super(key: key);

  @override
  State<SearchHomePage> createState() => _SearchHomePageState();
}

class _SearchHomePageState extends BasePopState<SearchHomePage>
    with TickerProviderStateMixin {
  var isShowMap = false;

  int selectedIndex = 1;

  late SearchHomeCubit _bloc;

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
    pageController = PageController(initialPage: selectedIndex);
    pageController.addListener(() {
      var newPage = pageController.page!.round();
     _bloc.jumToPage(newPage);
    });
    textEditingController = TextEditingController();

    itemOnChange
        .debounceTime(const Duration(seconds: 1))
        .listen((value) => Utils.fireEvent(
              SearchHomeEvent(selectedIndex, value),
            ));

    _bloc = SearchHomeCubit();

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
      body: SizedBox(
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
                physics: NeverScrollableScrollPhysics(),
                controller: pageController,
                children:  [
                  AllPage(),
                  PlacesPage(index: 1, onCallBackShowMap: (i) {},),
                  RoutesPage(),
                  PersonsPage(index: 3,)
                ],
              ),
            ),
          ],
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
          top: MediaQuery.of(context).padding.top + 10.w,
          right: 10.w,
          left: 10.w),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: colorGrey50,
              size: 30,
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          Expanded(
            child: TextField(
              onChanged: (str) => itemOnChange.add(str),
              controller: textEditingController,
              autofocus: true,
              cursorColor: colorOrange90,
              cursorHeight: 20.h,
              style: typoSmallTextRegular.copyWith(color: colorWhite),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.hinTextSearchHome,
                hintStyle: typoSuperSmallTextRegular.copyWith(
                    color: colorGrey50, fontSize: 13.sp),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: colorTransparent),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: colorTransparent),
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: colorGrey60,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: const Icon(
                    Icons.search_outlined,
                    color: Colors.white,
                  ),
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    clearText();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
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
      AppLocalizations.of(context)!.all,
      AppLocalizations.of(context)!.places,
      AppLocalizations.of(context)!.routes,
      AppLocalizations.of(context)!.persons
    ];

    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height / 19.h,
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
                padding: EdgeInsets.only(left: 17.w, right: 17.w),
                margin: EdgeInsets.only(left: 6.w),
                alignment: Alignment.center,
                decoration: (state is InitState && index == 1) ||
                        (state is ChangeTabState && state.index == index)
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
                        color: colorGrey60),
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
