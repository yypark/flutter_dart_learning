import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;

void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  const MyApp({@required this.title});

  final String title;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, Marker> _markers = {};
  final Map<String, String> _officeAddr = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
        _officeAddr[office.name] = office.address;
      } // for-loop

    }); // setState()


  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(

          appBar: AppBar(
            title: const Text('Google Office Locations'),
            backgroundColor: Colors.blue[70],
          ), // appBar


          body: Column(
                  children: [
                    Flexible(
                      flex: 2,
                      child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: const LatLng(0, 0),
                              zoom: 2,),
                            markers: _markers.values.toSet(),

                        ), // GoogleMap
                    ), // Flexible
                    Flexible(
                      flex: 3,
                      child: OfficeList(officelocs: _officeAddr, marker_args: _markers),
                    ), // Flexible
                  ], // children
                ), // Column, body

        ), // Scaffold, home
      );



} // class _MyAppState()



class OfficeList extends StatelessWidget { 
    const OfficeList({
        Key key,
        @required this.officelocs,
        @required this.marker_args,
    }) : super(key: key);

    final Map<String, String> officelocs;
    final Map<String, Marker> marker_args;

    @override
    Widget build(BuildContext context) {
      return ListView.builder(

        itemCount: officelocs.length,
        itemBuilder: (builder, index) {
          final list_officelocs = officelocs.entries.toList();

          return ListTile(
            title: Text(list_officelocs[index].key),
            subtitle: Text(list_officelocs[index].value),
            
            onTap: () { CameraUpdate.newCameraPosition(
                  CameraPosition(
                    //target: marker_args[list_officelocs[index].key].position,
                    target: const LatLng(37.7786, -122.4375),
                    zoom: 16,
                  ), // CameraPosition 
                ); // CameraUpdate
            },               
            

          ); // ListTile
        }, // itemBuilder
      ); // ListView.builder
    }

} // class OfficeList()


