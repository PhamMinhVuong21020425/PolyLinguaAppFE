import 'package:flutter/material.dart';

class ButtonSummarize extends StatefulWidget {
  const ButtonSummarize({super.key});

  @override
  State<ButtonSummarize> createState() => _ButtonSummarizeState();
}

class _ButtonSummarizeState extends State<ButtonSummarize>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;
  final String _summary =
      'Đây là một đoạn văn bản tóm tắt nội dung. Nó sẽ được hiển thị từ từ khi bạn bấm vào nút.';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                  if (_isExpanded) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                });
              },
              child: const Text('Summarize Article'),
            ),
            SizeTransition(
              sizeFactor: _animation,
              axisAlignment: -1.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_summary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
