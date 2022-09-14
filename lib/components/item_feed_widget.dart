import 'package:base_bloc/components/thumbnail_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/model/feed_model.dart';
import 'app_like_button.dart';
import 'app_text.dart';

class ItemFeed extends StatefulWidget {
  final FeedModel model;

  const ItemFeed({Key? key, required this.model}) : super(key: key);

  @override
  State<ItemFeed> createState() => _ItemFeedState();
}

class _ItemFeedState extends State<ItemFeed> {
  bool isLike = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              height: size.height / 12,
              margin: EdgeInsets.only(top: 5.h),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15.w, top: 5.h),
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            'Adam Kowalski',
                            maxLine: 1,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w400),
                          ),
                          Row(
                            children: [
                              const AppText(
                                '2h',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Container(
                                width: 5.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(100)),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              const AppText(
                                'Murall',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              const Icon(
                                Icons.public,
                                color: Colors.grey,
                                size: 18,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
            ),
            widget.model.videoURL.isNotEmpty
                ? ThumbnailApp(
                    callbackOpenVideo: () {
                      /*  NavigatorUtils.moveBottomToTop(
                    VideoApp(
                      model: widget.model,
                    ),
                    context);*/
                    },
                  )
                : widget.model.photoURL != null &&
                        widget.model.photoURL!.isNotEmpty
                    ? Image.asset(widget.model.photoURL ?? '')
                    : const SizedBox(),
            Container(
              height: size.height / 10,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.orange],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppText(
                      "8A",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppText(
                              'Adam',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            AppText(
                              '2022-05-02',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ],
                        ),
                        Center(
                          child: Row(
                            children: [
                              AppText(
                                'Routes 12m',
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 15),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Icon(
                                Icons.circle_sharp,
                                size: 8,
                                color: Colors.grey[400],
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              AppText(
                                'Adam Kowalski',
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 15),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            widget.model.isShowInfomation
                ? Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                        color: Colors.black,
                        height: size.height / 12,
                        // child: Column()
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '1',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '2',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Grade',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.playlist_add,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Playlist',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Belay: Toprope',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Support: Yes',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : Container(
                    padding:
                        EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                    color: Colors.black,
                    height: size.height / 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              '1',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.playlist_add,
                                color: Colors.white,
                              ),
                            ),
                            AppText(
                              'Playlist',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            Divider(
              thickness: 1.h,
              color: Colors.grey,
              indent: 1.w,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Row(
                    children: [
                      AppLikeButton(),
                    ],
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.mode_comment_outlined,
                        color: Colors.white,
                      ),
                      Row(
                        children: [
                          Text(
                            '10',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            'Comments',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w, top: 10.h, bottom: 10.h),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppText(
                              'Zoe Smith',
                              style: TextStyle(color: Colors.white),
                            ),
                            Expanded(
                                child: AppText(
                              " - there kj akjf shjfsh dfhjskd fhjks hdfhja sdasdasda",
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ))
                          ],
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            'Show more',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
