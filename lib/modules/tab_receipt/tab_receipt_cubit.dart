import 'package:base_bloc/modules/tab_receipt/tab_receipt_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/constant.dart';
import '../../data/model/bill_model.dart';
import '../../data/model/calender_param.dart';
import '../../router/router.dart';
import '../../router/router_utils.dart';
import '../../utils/app_utils.dart';


class TabReceiptCubit extends Cubit<TabReceiptState>{
  TabReceiptCubit() : super( TabReceiptState(calender: CalenderParam(name: "Hôm nay")));

  void onClickSearch(BuildContext context) => RouterUtils.pushRoutes(
      context: context,
      route: ReceiptRouters.search,
      argument: BottomNavigationConstant.TAB_RECEIPT);

  void onClickNotification(BuildContext context) => /*toast(LocaleKeys.thisFeatureIsUnder);*/
      RouterUtils.pushRoutes(
      context: context,
      route: ReceiptRouters.notifications,
      argument: BottomNavigationConstant.TAB_RECEIPT);

  void onClickLogin(BuildContext context) async {
    await RouterUtils.pushRoutes(
        context: context,
        route: ReceiptRouters.login,
        argument: BottomNavigationConstant.TAB_RECEIPT);
    emit(TabReceiptState(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void onClickCalender (BuildContext context) {
    Utils.showCalenderDialog(context, (type) async {
      Navigator.of(context).pop();
      // state.calender = type;
      emit(state.copyOf(
        calender: type,
      ));
    }, state.calender);
  }

  void openBillDetail(BuildContext context, BillModel model) {
    RouterUtils.pushRoutes(context: context, route: ReceiptRouters.routesBillDetail,argument: [BottomNavigationConstant.TAB_RECEIPT,model]);
  }


}


List<BillModel> fakeDataBill() => [
  BillModel("A101","Nguyễn Thị Hồng", "400,000", "1/12/2022", "4"),
  BillModel("A102","Phạm Tiến Đức", "230,000", "1/12/2022", "6"),
  BillModel("A103","Trần Quang Thọ", "150,000", "2/12/2022", "4"),
  BillModel("A104","Đinh Văn Hà", "190,000", "5/12/2022", "8"),
  BillModel("A105","Lê Đức Độ", "345,000", "6/12/2022", "8"),
  BillModel("A106","Bùi Việt Hoàng", "123,000", "8/12/2022", "5"),
  BillModel("A107","Hoàng Hải Đăng", "548,000", "15/12/2022", "9"),
  BillModel("A108","Quách Thị Tâm", "145,000", "16/12/2022", "6"),
  BillModel("A109","Vũ Thu Trang", "268,000", "19/12/2022", "5"),
  BillModel("A110","Lý Công Nam", "169,000", "26/12/2022", "7 "),
];
