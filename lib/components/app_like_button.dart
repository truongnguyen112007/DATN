import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class AppLikeButton extends StatefulWidget {
  const AppLikeButton({Key? key}) : super(key: key);

  @override
  State<AppLikeButton> createState() => _AppLikeButtonState();
}

class _AppLikeButtonState extends State<AppLikeButton> {
  bool isLiked = false;
  int likeCount = 5;

  @override
  Widget build(BuildContext context) {
    final double size = 40;
    return LikeButton(
      likeCountAnimationType: LikeCountAnimationType.none,
      crossAxisAlignment: CrossAxisAlignment.start,
      size: size,
      countPostion: CountPostion.bottom,
      isLiked: isLiked,
      likeCount: likeCount,
      countBuilder: (int? count, bool isLiked, String text) {
        return Text(
          '$count likes',
          style: TextStyle(color: Colors.grey),
        );
      },
      likeBuilder: (bool isLiked) {
        if (!isLiked) {
          return Icon(Icons.favorite_border_outlined, color: Colors.grey);
        }
        return Icon(Icons.favorite, color: Colors.red);
      },
    );
  }
}
