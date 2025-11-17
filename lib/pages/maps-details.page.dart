import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../menu/drawer.widget.dart';

class MapsDetailsPage extends StatefulWidget {
  String latitude;
  String longitude;

  MapsDetailsPage({this.latitude = "", this.longitude = ""});

  @override
  State<MapsDetailsPage> createState() => _MapsDetailsPageState();
}

class _MapsDetailsPageState extends State<MapsDetailsPage> {
  late GoogleMapController mapController;
  LatLng? position;
  Set<Marker> markers = {};
  MapType currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    getMapsData(widget.latitude, widget.longitude);
  }

  void getMapsData(String latitude, String longitude) {
    print("Maps data: $latitude, $longitude");
    try {
      double lat = double.parse(latitude);
      double lng = double.parse(longitude);

      setState(() {
        position = LatLng(lat, lng);
        markers.add(Marker(
          markerId: MarkerId('selected-location'),
          position: position!,
          infoWindow: InfoWindow(
            title: 'Position sélectionnée',
            snippet: 'Lat: $latitude, Lng: $longitude',
          ),
        ));
        print("Position: $position");
      });
    } catch (e) {
      print("Erreur: $e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _changeMapType() {
    setState(() {
      currentMapType =
          currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Maps Details')),
      drawer: MyDrawer(),
      body: position == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: position!,
                zoom: 12.0,
              ),
              markers: markers,
              mapType: currentMapType,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              compassEnabled: true,
              myLocationEnabled: true,
             myLocationButtonEnabled: true,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeMapType,
        child: Icon(Icons.map),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
