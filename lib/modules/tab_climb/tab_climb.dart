import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:flutter/cupertino.dart';
import '../../theme/colors.dart';

class TabClimb extends StatefulWidget {
  const TabClimb({Key? key}) : super(key: key);

  @override
  State<TabClimb> createState() => _TabClimbState();
}

class _TabClimbState extends State<TabClimb> with TickerProviderStateMixin {
  var isShowMap = false;

  int selectedIndex = 1;

  TextEditingController? textEditingController;

  var pageController = PageController();

  void _jumpToPage(int index) {
    selectedIndex = index;
    if(pageController.hasClients)
    pageController.jumpToPage(selectedIndex);
  }

  @override
  void initState() {
    if(pageController.hasClients)
    pageController.addListener(() {
      var newPage = pageController.page!.round();
      _jumpToPage(newPage);
    });

    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    textEditingController?.dispose();
    super.dispose();
  }

  var controller = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: AlwaysScrollableScrollPhysics(),
      // controller: pageController,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: colorOrange100,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: colorBlue82,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: colorGrey50,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: colorPink40,
        ),
      ],
    );
    return PageView(
      /// [PageView.scrollDirection] defaults to [Axis.horizontal].
      /// Use [Axis.vertical] to scroll vertically.
      controller: controller,
      children: <Widget>[
        Center(
          child: Text(
            'First Page',
            style: typoSmallTextRegular.copyWith(color: colorWhite),
          ),
        ),
        Center(
          child: Text(
            'Second Page',
            style: typoSmallTextRegular.copyWith(color: colorWhite),
          ),
        ),
        Center(
          child: Text(
            'Third Page',
            style: typoSmallTextRegular.copyWith(color: colorWhite),
          ),
        ),
      ],
    );

    return AppScaffold(
      backgroundColor: colorBlack,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            /*   appBar(),
            SizedBox(
              height: 10.h,
            ),
            category(),
            SizedBox(
              height: 8.h,
            ),
            const Divider(thickness: 0, color: colorGrey50, height: 2),
            FilterWidget(
                sortCallBack: () {},
                filterCallBack: () {},
                selectCallBack: () {}),*/
            Expanded(
              child: PageView(
                controller: pageController,
                physics: AlwaysScrollableScrollPhysics(),
                // controller: pageController,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: colorOrange100,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: colorBlue82,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: colorGrey50,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: colorPink40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
