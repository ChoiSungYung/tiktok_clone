import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class PostVideoButton extends StatefulWidget {
  const PostVideoButton({super.key});

  @override
  State<PostVideoButton> createState() => _PostVideoButtonState();
}

class _PostVideoButtonState extends State<PostVideoButton> {
  bool _onVideoButtonTapDown = false;

  void _onTapDown() {
    setState(() {
      _onVideoButtonTapDown = true;
    });
  }

  void _onTapUp() {
    setState(() {
      _onVideoButtonTapDown = false;
      _onPostVideoButtonTap();
    });
  }

  void _onPostVideoButtonTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Record video'),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressDown: (details) => _onTapDown(),
      onLongPressUp: _onTapUp,
      onTap: _onPostVideoButtonTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 20,
            child: Container(
              height: 30,
              width: 25,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xff61D4F0),
                borderRadius: BorderRadius.circular(
                  Sizes.size8,
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            child: Container(
              height: 30,
              width: 25,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size8,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(
                  Sizes.size8,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 30,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size12,
            ),
            decoration: BoxDecoration(
              color: _onVideoButtonTapDown ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(
                Sizes.size6,
              ),
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.plus,
                color: _onVideoButtonTapDown ? Colors.white : Colors.black,
                size: 18,
              ),
            ),
          )
        ],
      ),
    );
  }
}
