import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/data/eventbus/hide_bottom_bar_event.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

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
        videoPlayerController: _videoPlayerController!,
        looping: true,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  Widget _chewieVideoPlayer() {
    return _chewieController != null && _videoPlayerController != null
        ? Container(
            child: Chewie(controller: _chewieController!),
          )
        : Center(
            child: Text("Please wait"),
          );
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: [
          _chewieVideoPlayer(),
          Padding(
              padding: EdgeInsets.only(
                  left: contentPadding,
                  top: MediaQuery.of(context).padding.top + contentPadding),
              child: InkWell(
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100),
                          color: colorGrey5,
                        ),
                    child: const Icon(Icons.arrow_back_outlined),
                  ),
                  onTap: () => goBack(context)))
        ],
      ),
    );
  }

  void goBack(BuildContext context) {
    RouterUtils.pop(context);
  }

  @override
  int get tabIndex => widget.index;

  @override
  bool get isNewPage => true;
}
