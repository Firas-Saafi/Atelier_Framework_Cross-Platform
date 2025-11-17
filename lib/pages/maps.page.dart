import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../menu/drawer.widget.dart';
import 'maps-details.page.dart';

class Maps extends StatelessWidget {
  TextEditingController txt_ville = TextEditingController();
  TextEditingController txt_latitude = TextEditingController();
  TextEditingController txt_longitude = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: const Text('Maps'),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                  controller: txt_ville,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_city),
                      hintText: "Nom de ville",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)))),
            ),
            Center(
                child: Text("OU",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: txt_latitude,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on),
                    hintText: "Latitude",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: txt_longitude,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on),
                    hintText: "Longitude",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () {
                      _onGetMapsDetails(context);
                    },
                    child: Text('Chercher', style: TextStyle(fontSize: 22)))),
            Container(
                padding: EdgeInsets.all(10),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      _getCurrentLocation(context);
                    },
                    icon: Icon(Icons.my_location),
                    label: Text('Ma position actuelle',
                        style: TextStyle(fontSize: 22)))),
          ],
        ));
  }

  void _onGetMapsDetails(BuildContext context) {
    String ville = txt_ville.text;
    String latitude = txt_latitude.text;
    String longitude = txt_longitude.text;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapsDetailsPage(
                  latitude: latitude,
                  longitude: longitude,
                )));

    txt_ville.text = "";
    txt_latitude.text = "";
    txt_longitude.text = "";
  }

  void _getCurrentLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Veuillez activer les services de localisation')));
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Permission de localisation refusée')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Permission de localisation refusée définitivement')));
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapsDetailsPage(
                  latitude: position.latitude.toString(),
                  longitude: position.longitude.toString(),
                )));
  }
}
