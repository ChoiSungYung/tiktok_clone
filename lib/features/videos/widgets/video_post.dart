import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/widgets/video_comments.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../constants/gaps.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  final int index;
  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/love.mp4");
  bool _isPaused = false;
  bool _isMuted = false;

  final Duration _animationDuration = const Duration(milliseconds: 200);

  late final AnimationController _animationController;
  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset("assets/videos/love.mp4");
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
      _isMuted = true;
    }
    _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onVolumeToggle() {
    if (kIsWeb && !_isMuted) {
      _videoPlayerController.setVolume(0);
      setState(() {
        _isMuted = !_isMuted;
      });
    } else if (kIsWeb && _isMuted) {
      _videoPlayerController.setVolume(10);
      setState(() {
        _isMuted = !_isMuted;
      });
    }
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => const VideoComments(),
    );
    _onTogglePause();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animationController.value,
                    child: child,
                  );
                },
                child: Center(
                  child: Transform.scale(
                    scale: _animationController.value,
                    child: AnimatedOpacity(
                      opacity: _isPaused ? 1 : 0,
                      duration: _animationDuration,
                      child: const FaIcon(
                        FontAwesomeIcons.play,
                        color: Colors.white,
                        size: Sizes.size52,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "@니꼬",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Sizes.size20,
                  ),
                ),
                Gaps.v10,
                Text(
                  "This is my house in Thiland!!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size16,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/93511360?s=40&v=4"),
                  child: Text("니꼬"),
                ),
                Gaps.v20,
                const VideoButton(
                    icon: FontAwesomeIcons.solidHeart, text: "2.9M"),
                Gaps.v10,
                GestureDetector(
                  onTap: () => _onCommentsTap(context),
                  child: const VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: "33K",
                  ),
                ),
                Gaps.v10,
                const VideoButton(icon: FontAwesomeIcons.share, text: "Share"),
              ],
            ),
          ),
          if (kIsWeb)
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: () => _onVolumeToggle(),
                child: VideoButton(
                  icon: _isMuted
                      ? FontAwesomeIcons.volumeXmark
                      : FontAwesomeIcons.volumeHigh,
                  text: _isMuted ? "mute" : "on",
                ),
              ),
            ),
        ],
      ),
    );
  }
}
