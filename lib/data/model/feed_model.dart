class FeedModel {
  final bool isShowInfomation;
  final String videoURL;
  final String? photoURL;
   bool isAddToPlaylist;

  FeedModel(this.isShowInfomation, this.videoURL, {this.photoURL,this.isAddToPlaylist = false});
}
