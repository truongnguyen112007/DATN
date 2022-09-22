/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import

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

  /// File path: assets/png/doctor.png
  AssetGenImage get doctor => const AssetGenImage('assets/png/doctor.png');

  /// File path: assets/png/person.png
  AssetGenImage get person => const AssetGenImage('assets/png/person.png');

  /// File path: assets/png/test.png
  AssetGenImage get test => const AssetGenImage('assets/png/test.png');
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/avatar_test.png
  AssetGenImage get avatarTest =>
      const AssetGenImage('assets/svg/avatar_test.png');

  /// File path: assets/svg/back_circle.svg
  String get backCircle => 'assets/svg/back_circle.svg';

  /// File path: assets/svg/doctor.png
  AssetGenImage get doctor => const AssetGenImage('assets/svg/doctor.png');

  /// File path: assets/svg/doctor_background.svg
  String get doctorBackground => 'assets/svg/doctor_background.svg';
}

class Assets {
  Assets._();

  static const $AssetsPngGen png = $AssetsPngGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
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

  String get path => _assetName;

  String get keyName => _assetName;
}
