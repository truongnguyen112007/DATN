import 'package:base_bloc/modules/tab_more/tab_more_cubit.dart';
import 'package:base_bloc/modules/tab_more/tab_more_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/app_scalford.dart';
import '../../components/app_text.dart';
import '../../gen/assets.gen.dart';
import '../../utils/log_utils.dart';
import '../login/login.dart';

class TabMore extends StatefulWidget {
  const TabMore({Key? key}) : super(key: key);

  @override
  State<TabMore> createState() => _TabMoreState();
}

class _TabMoreState extends State<TabMore> {
  late final TabMoreCubit _bloc;

  @override
  void initState() {
    _bloc = TabMoreCubit();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      fullStatusBar: true,
        backgroundColor: colorText5,
        body: Column(children: [
          Container(height: MediaQuery.of(context).padding.top,color: colorGreen60.withOpacity(0.3),),
          Container(
            height: 70.h,
            color: colorGreen60.withOpacity(0.3),
            child: Row(
              children: [
                SizedBox(
                  width: 20.w,
                ),
                Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: colorRed80),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      "AAA",
                      style: googleFont.copyWith(
                          color: colorBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp),
                    ),
                    AppText(
                      "Chi nhánh trung tâm",
                      style: googleFont.copyWith(
                          color: colorBlack,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: BlocBuilder<TabMoreCubit,TabMoreState>(
              bloc: _bloc,
              builder: (c,s) =>
               Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          item(() {}, icon: Icons.directions, text: "Trả hàng"),
                          item(() {},
                              icon: Icons.reply_all, text: "Trả hàng nhập"),
                          item(() {},
                              icon: Icons.delete_forever, text: "Xuất hủy"),
                          item(() {_bloc.onClickSupplier(context);}, icon: Icons.group, text: "Nhà cung cấp"),
                          item(() {}, icon: Icons.poll_outlined, text: "Báo cáo"),
                        ],
                      ),
                      Column(
                        children: [
                          item(() {},
                              icon: Icons.shopping_bag_outlined,
                              text: "Đặt hàng"),
                          item(() {},
                              icon: Icons.assignment_returned, text: "Nhập hàng"),
                          item(() {},
                              icon: Icons.content_paste_go, text: "Kiểm kho"),
                          item(() {}, icon: Icons.person, text: "Khách hàng"),
                          item(() {},
                              icon: Icons.account_balance_wallet_outlined,
                              text: "Sổ quỹ"),
                        ],
                      )
                    ],
                  ),
                  extensions(),
                  support()
                ],
              ),
            ),
          )),
        ]));
  }

  Widget item(VoidCallback callback, {IconData? icon, String? text}) {
    return InkWell(
      splashColor: colorTransparent,
      onTap: callback,
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        height: 60.h,
        width: 160.w,
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: colorGrey30,
              spreadRadius: 1.2,
              blurRadius: 0.3,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Row(
            children: [
              Icon(icon),
              SizedBox(
                width: 5.w,
              ),
              AppText(
                text!,
                style: googleFont.copyWith(
                    fontSize: 14.sp,
                    color: colorBlack,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget extensions() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 20.h, bottom: 20.h, left: 10.w, right: 10.w),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: colorGrey30,
            spreadRadius: 1.2,
            blurRadius: 0.3,
          ),
        ],
      ),
      child: Column(
        children: [
          itemExtensions("Giao hàng", "Cước rẻ, đa hãng, tối ưu vận hành",Assets.png.icongh.path),
          divider(),
          itemExtensions("Website bán hàng", "Dễ dàng kinh doanh trực tuyến",Assets.png.sellonline.path),
          divider(),
          itemExtensions("Bán online", "Trên facebook,tiktok shop & sàn TMĐT",Assets.png.www.path),
        ],
      ),
    );
  }

  Widget support() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.h),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: colorGrey30,
            spreadRadius: 1.2,
            blurRadius: 0.3,
          ),
        ],
      ),
      child: Column(
        children: [
          itemSupport(Icons.settings,"Cài đặt",colorBlack,(){}),
          divider(),
          itemSupport(Icons.call,"Gọi 1900 2007",colorBlack,(){}),
          divider(),
          itemSupport(Icons.error_outline_outlined,"Điều khoản",colorBlack,(){}),
          divider(),
          itemSupport(Icons.logout,"Đăng xuất",colorRed80,(){
            _bloc.logoutOnClick(context);
            // RouterUtils.push(context: context, route: route)
            // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
          }),
        ],
      ),
    );
  }

  Widget divider() {
    return Container(
      margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
      height: 1,
      color: colorGrey35,
    );
  }

  Widget itemExtensions(String text1, String text2,String image,) {
    return Row(
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: Container(
            height: 40.h,
            width: 40.h,
            child: Image.asset(image),
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text1,
              style: googleFont.copyWith(
                  color: colorBlack,
                  fontWeight: FontWeight.w700,
                  fontSize: 17.sp),
            ),
            AppText(text2,
                style: googleFont.copyWith(
                    color: colorBlack,
                    fontWeight: FontWeight.w200,
                    fontSize: 12.sp))
          ],
        ),
        const Spacer(),
        const Icon(Icons.navigate_next)
      ],
    );
  }

  Widget itemSupport (IconData icon,String text,Color color,VoidCallback callback) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: callback,
        child: Row(
          children: [
            Icon(icon,color: color,),
            SizedBox(width: 20.w,),
            AppText(text,style: googleFont.copyWith(color: color,fontWeight: FontWeight.w700,fontSize: 18.sp),)
          ],
        ),
      ),
    );
  }
}
