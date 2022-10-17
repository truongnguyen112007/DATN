import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/chwie/src/chewie_progress_colors.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../data/model/feed_model.dart';
import 'chwie/src/chewie_player.dart';

class AppVideo extends StatefulWidget {
  final int index;
  final FeedModel model;

  const AppVideo({Key? key, required this.model, required this.index})
      : super(key: key);

  @override
  _AppVideoState createState() => _AppVideoState();
}

class _AppVideoState extends BasePopState<AppVideo> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.network(widget.model.videoURL);
    _videoPlayerController!.initialize().then((_) {
      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!, looping: true);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  Widget videoPlayer() {
    return _chewieController != null && _videoPlayerController != null
        ? Chewie(controller: _chewieController!)
        : const Center(
            child: AppCircleLoading(),
          );
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: [
          videoPlayer(),
          Padding(
              padding: EdgeInsets.only(left: contentPadding, top: 3),
              child: InkWell(
                  child: Container(
                    height: 26.w,
                    width: 26.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: colorGrey5,
                    ),
                    child: const Icon(
                      Icons.arrow_back_outlined,
                      size: 20,
                    ),
                  ),
                  onTap: () => RouterUtils.pop(context)))
        ],
      ),
    );
  }

  @override
  int get tabIndex => widget.index;

  @override
  bool get isNewPage => true;
}
