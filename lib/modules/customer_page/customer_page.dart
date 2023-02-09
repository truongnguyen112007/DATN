import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:flutter/cupertino.dart';

class CustomerPage extends StatefulWidget {
  final int routePage;

  const CustomerPage({Key? key, required this.routePage}) : super(key: key);

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends BasePopState<CustomerPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(body: Container());
  }

  @override
  int get tabIndex => widget.routePage;
}
