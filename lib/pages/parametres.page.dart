import 'package:flutter/material.dart';

import '../../menu/drawer.widget.dart';

class Parametres extends StatelessWidget {
  const Parametres({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  MyDrawer(),
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: const Center(
        child: Text(
          'Page Parametres',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}