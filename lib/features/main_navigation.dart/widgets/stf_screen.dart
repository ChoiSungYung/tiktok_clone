import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class StfScreen extends StatefulWidget {
  const StfScreen({super.key});

  @override
  State<StfScreen> createState() => _StfScreenState();
}

class _StfScreenState extends State<StfScreen> {
  int _clicks = 0;
  void _increase() {
    setState(() {
      _clicks = _clicks + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('im built');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$_clicks",
            style: const TextStyle(fontSize: Sizes.size48),
          ),
          TextButton(
            onPressed: _increase,
            child: const Text(
              "+",
              style: TextStyle(fontSize: Sizes.size24),
            ),
          )
        ],
      ),
    );
  }
}
