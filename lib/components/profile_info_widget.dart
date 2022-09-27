import 'package:base_bloc/data/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../localizations/app_localazations.dart';
import 'app_text.dart';

class ProfileInfoWidget extends StatelessWidget {
  final UserModel userModel;
  final VoidCallback onPressEditProfile;

  const ProfileInfoWidget(
      {Key? key, required this.userModel, required this.onPressEditProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40.0,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                      child: Image.network(
                    userModel.avatar ?? '',
                    fit: BoxFit.cover,
                    width: 80.0,
                    height: 80.0,
                  )),
                ),
                const SizedBox(width: 20.0),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(userModel.name ?? '',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 25,
                              fontWeight: FontWeight.w600)),
                      AppText(userModel.type ?? '',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w400))
                    ])
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Container(color: Colors.grey, height: 0.5),
          Container(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(AppLocalizations.of(context)!.countPassed,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w400)),
                      AppText(userModel.passed.toString(),
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 26,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  const SizedBox(width: 50.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(AppLocalizations.of(context)!.countDesigned,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w400)),
                      AppText(userModel.designed.toString(),
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 26,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  const SizedBox(width: 50.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(AppLocalizations.of(context)!.countFriends,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w400)),
                      AppText(userModel.friends.toString(),
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 26,
                              fontWeight: FontWeight.w600))
                    ],
                  )
                ],
              )),
          Container(
            padding: EdgeInsets.only(top: 20.0, left: 20.0, bottom: 20.0),
            child: TextButton(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(AppLocalizations.of(context)!.editSettings,
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.white70,
                  onSurface: Colors.black,
                  side: BorderSide(color: Colors.white70, width: 1.5),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                ),
                onPressed: () => onPressEditProfile()),
          )
        ],
      ),
    );
  }
}
