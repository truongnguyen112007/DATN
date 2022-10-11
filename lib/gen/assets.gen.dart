/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal

import 'package:flutter/widgets.dart';

class $AssetsPngGen {
  const $AssetsPngGen();

  /// File path: assets/png/climbing1.png
  AssetGenImage get climbing1 =>
      const AssetGenImage('assets/png/climbing1.png');

  /// File path: assets/png/climbing2.png
  AssetGenImage get climbing2 =>
      const AssetGenImage('assets/png/climbing2.png');

  /// File path: assets/png/climbing3.png
  AssetGenImage get climbing3 =>
      const AssetGenImage('assets/png/climbing3.png');

  /// File path: assets/png/climbing4.png
  AssetGenImage get climbing4 =>
      const AssetGenImage('assets/png/climbing4.png');

  /// File path: assets/png/climbing5.png
  AssetGenImage get climbing5 =>
      const AssetGenImage('assets/png/climbing5.png');

  /// File path: assets/png/climbing6.png
  AssetGenImage get climbing6 =>
      const AssetGenImage('assets/png/climbing6.png');

  /// File path: assets/png/doctor.png
  AssetGenImage get doctor => const AssetGenImage('assets/png/doctor.png');

  /// File path: assets/png/ic_account.png
  AssetGenImage get icAccount =>
      const AssetGenImage('assets/png/ic_account.png');

  /// File path: assets/png/ic_friends.png
  AssetGenImage get icFriends =>
      const AssetGenImage('assets/png/ic_friends.png');

  /// File path: assets/png/ic_notification.png
  AssetGenImage get icNotification =>
      const AssetGenImage('assets/png/ic_notification.png');

  /// File path: assets/png/ic_privacy.png
  AssetGenImage get icPrivacy =>
      const AssetGenImage('assets/png/ic_privacy.png');

  /// File path: assets/png/ic_private.png
  AssetGenImage get icPrivate =>
      const AssetGenImage('assets/png/ic_private.png');

  /// File path: assets/png/ic_public.png
  AssetGenImage get icPublic => const AssetGenImage('assets/png/ic_public.png');

  /// File path: assets/png/ic_setting.png
  AssetGenImage get icSetting =>
      const AssetGenImage('assets/png/ic_setting.png');

  /// File path: assets/png/liked.png
  AssetGenImage get liked => const AssetGenImage('assets/png/liked.png');

  /// File path: assets/png/person.png
  AssetGenImage get person => const AssetGenImage('assets/png/person.png');

  /// File path: assets/png/test.png
  AssetGenImage get test => const AssetGenImage('assets/png/test.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        climbing1,
        climbing2,
        climbing3,
        climbing4,
        climbing5,
        climbing6,
        doctor,
        icAccount,
        icFriends,
        icNotification,
        icPrivacy,
        icPrivate,
        icPublic,
        icSetting,
        liked,
        person,
        test
      ];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/add_play_list.svg
  String get addPlayList => 'assets/svg/add_play_list.svg';

  /// File path: assets/svg/avatar_test.png
  AssetGenImage get avatarTest =>
      const AssetGenImage('assets/svg/avatar_test.png');

  /// File path: assets/svg/back_circle.svg
  String get backCircle => 'assets/svg/back_circle.svg';

  /// File path: assets/svg/comment.svg
  String get comment => 'assets/svg/comment.svg';

  /// File path: assets/svg/doctor.png
  AssetGenImage get doctor => const AssetGenImage('assets/svg/doctor.png');

  /// File path: assets/svg/doctor_background.svg
  String get doctorBackground => 'assets/svg/doctor_background.svg';

  /// File path: assets/svg/like.svg
  String get like => 'assets/svg/like.svg';

  /// File path: assets/svg/liked.svg
  String get liked => 'assets/svg/liked.svg';

  /// File path: assets/svg/more_vertical.svg
  String get moreVertical => 'assets/svg/more_vertical.svg';

  /// File path: assets/svg/notification.svg
  String get notification => 'assets/svg/notification.svg';

  /// File path: assets/svg/os.svg
  String get os => 'assets/svg/os.svg';

  /// File path: assets/svg/play.svg
  String get play => 'assets/svg/play.svg';

  /// File path: assets/svg/playlistadd.svg
  String get playlistadd => 'assets/svg/playlistadd.svg';

  /// File path: assets/svg/relimb-dark.svg
  String get relimbDark => 'assets/svg/relimb-dark.svg';

  /// File path: assets/svg/search.svg
  String get search => 'assets/svg/search.svg';

  /// List of all assets
  List<dynamic> get values => [
        addPlayList,
        avatarTest,
        backCircle,
        comment,
        doctor,
        doctorBackground,
        like,
        liked,
        moreVertical,
        notification,
        os,
        play,
        playlistadd,
        relimbDark,
        search
      ];
}

class $AssetsTdGen {
  const $AssetsTdGen();

  /// File path: assets/td/boombox.glb
  String get boombox => 'assets/td/boombox.glb';

  /// List of all assets
  List<String> get values => [boombox];
}

class Assets {
  Assets._();

  static const $AssetsPngGen png = $AssetsPngGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
  static const $AssetsTdGen td = $AssetsTdGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider() => AssetImage(_assetName);

  String get path => _assetName;

  String get keyName => _assetName;
}
