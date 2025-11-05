import 'package:flutter/material.dart';

import '../../menu/drawer.widget.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  MyDrawer(),
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: const Center(
        child: Text(
          'Page Contacts',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}