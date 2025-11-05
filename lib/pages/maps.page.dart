import 'package:flutter/material.dart';

import '../../menu/drawer.widget.dart';

class Maps extends StatelessWidget {
  const Maps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  MyDrawer(),
      appBar: AppBar(
        title: const Text('Maps'),
      ),
      body: const Center(
        child: Text(
          'Page Maps',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}