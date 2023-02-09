import 'package:base_bloc/modules/place_address/address/address_state.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/constant.dart';
import '../../../data/model/reservation_model.dart';
import '../../../router/router.dart';
import '../../../router/router_utils.dart';

class AddressCubit extends Cubit<AddressState> {
  final int index;
  AddressCubit(this.index): super (const AddressState());

  void addOnclick(BuildContext context)  {
     switch(index) {
       case BottomNavigationConstant.TAB_OVERVIEW :
         RouterUtils.pushOverView(context: context, route: OverViewRouters.routesCreateReservationPage,argument: index);
         break;
       case BottomNavigationConstant.TAB_RECEIPT :
         RouterUtils.pushRoutes(context: context, route: ReceiptRouters.routesCreateReservationPage,argument: index);
         break;
       case BottomNavigationConstant.TAB_CLIMB :
         RouterUtils.pushClimb(context: context, route: GoodsRouters.routesCreateReservationPage,argument: index);
         break;
       case BottomNavigationConstant.TAB_RESERVATIONS :
         RouterUtils.pushNotification(context: context, route: NotificationRouters.routesCreateReservationPage,argument: index);
         break;
       case BottomNavigationConstant.TAB_PROFILE :
         RouterUtils.pushProfile(context: context, route: ProfileRouters.routesCreateReservationPage,argument: index);
         break;
     }

  List<ReservationModel> fakeData() => [
    ReservationModel(
        calendar: DateTime.now(),
        startTime: '9:30',
        endTime: '10:30',
        address:
        'Wall no. 3 - Next to window Centurn Murall al.Kwasaaki 61 02-183 warsawa',
        status: 'Murall',
        isCheck: false, city: 'Warsaw'),
/*        ReservationModel(
            calendar: DateTime.now(),
            startTime: '10:30',
            endTime: '11:30',
            address:
                'Wall no. 3 - Next to window Centurn Murall al.Kwasaaki 61 02-183 warsawa',
            status: 'Kawasai',
            isCheck: false, city: 'Warsaw'),
        ReservationModel(
            calendar: DateTime.now(),
            startTime: '11:30',
            endTime: '12:30',
            address:
                'Wall no. 3 - Next to window Centurn Murall al.Kwasaaki 61 02-183 warsawa',
            status: 'Kawasai',
            isCheck: true, city: 'Warsaw'),*/
  ];}

}