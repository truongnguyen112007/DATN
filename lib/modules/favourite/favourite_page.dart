import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText(
        'Favourite PAGE',
        style: typoSmallTextRegular.copyWith(color: colorText0),
      ),
    );
  }
}
