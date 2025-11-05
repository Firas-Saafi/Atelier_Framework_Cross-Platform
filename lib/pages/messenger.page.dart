import 'package:flutter/material.dart';

import '../../menu/drawer.widget.dart';

class Messenger extends StatelessWidget {
  const Messenger({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  MyDrawer(),
      appBar: AppBar(
        title: const Text('Messenger'),
      ),
      body: const Center(
        child: Text(
          'Page Messenger',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}