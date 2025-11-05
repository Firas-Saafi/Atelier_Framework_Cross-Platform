import 'package:flutter/material.dart';

import '../../menu/drawer.widget.dart';

class ChatBot extends StatelessWidget {
  const ChatBot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  MyDrawer(),
      appBar: AppBar(
        title: const Text('ChatBot'),
      ),
      body: const Center(
        child: Text(
          'Page ChatBot',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}