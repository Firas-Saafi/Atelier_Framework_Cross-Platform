import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/global.params.dart';

class MyDrawer extends StatelessWidget {
  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blueAccent]
              )
            ),
            child: Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('images/profile.jpg'),
                radius: 60,
              ),
            )
          ),
         ...(GlobalParams.menus as List).map((item) {
            return Column(
              children: [
                const Divider(height: 4, color: Colors.blue),
                ListTile(
                  title: Text('${item['title']}', style: const TextStyle(fontSize: 22),),
                  leading: item['icon'],
                  trailing: const Icon(Icons.arrow_right, color: Colors.blue,),
                  onTap: () async {
                    if ('${item['title']}' != "Déconnexion") {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "${item['route']}");
                    }
                    else
                    {
                      prefs = await SharedPreferences.getInstance();
                      prefs.setBool("connecte", false);
                      Navigator.pushNamedAndRemoveUntil(context,
                        '/authentification', (route) => false);
                    }
                  },
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}

