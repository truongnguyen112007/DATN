import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';

class Photos extends StatefulWidget {
  const Photos({Key? key}) : super(key: key);

  @override
  State<Photos> createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorGreyBackground,
      body: Center(
        child: Text(
          "Photos",
          style: googleFont.copyWith(color: colorWhite),
        ),
      ),
    );
  }
}
