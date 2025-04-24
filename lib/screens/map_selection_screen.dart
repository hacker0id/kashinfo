import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSelectionScreen extends StatefulWidget {
  final Map<String, double> initialLocation;

  const MapSelectionScreen({
    Key? key,
    required this.initialLocation,
  }) : super(key: key);

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  late GoogleMapController mapController;
  LatLng? selectedLocation;
  bool isMapCreated = false;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    print(
        'MapSelectionScreen initialized with location: ${widget.initialLocation}');
    selectedLocation = LatLng(
      widget.initialLocation['lat']!,
      widget.initialLocation['long']!,
    );
    markers.add(
      Marker(
        markerId: const MarkerId('initial_location'),
        position: selectedLocation!,
        infoWindow: const InfoWindow(title: 'Initial Location'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (selectedLocation != null) {
                print(
                    'Location selected: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}');
                Navigator.pop(context, {
                  'lat': selectedLocation!.latitude,
                  'long': selectedLocation!.longitude,
                });
              } else {
                print('No location selected');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a location on the map'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.initialLocation['lat']!,
                widget.initialLocation['long']!,
              ),
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              print('Map created');
              mapController = controller;
              setState(() {
                isMapCreated = true;
              });
            },
            onTap: (LatLng location) {
              print(
                  'Map tapped at: ${location.latitude}, ${location.longitude}');
              setState(() {
                selectedLocation = location;
                markers.clear();
                markers.add(
                  Marker(
                    markerId: const MarkerId('selected_location'),
                    position: location,
                    infoWindow: const InfoWindow(title: 'Selected Location'),
                  ),
                );
              });
            },
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
            mapType: MapType.normal,
            compassEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
          ),
          if (!isMapCreated)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
