import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late List<MapLatLng> polyline;
  late List<List<MapLatLng>> plannedRoutes;
  late List<List<MapLatLng>> walkedRoutes;
  late _CustomZoomPanBehavior _zoomPanBehavior;
  late MapTileLayerController _controller;

  bool isChecked = false;

  List<String> items = ['item1', 'item2', 'item3'];
  String? selectedItem = 'item2';

  @override
  void initState() {
    polyline = <MapLatLng>[
      MapLatLng(51.449695, 7.266621),
      MapLatLng(51.450489, 7.268402),
      MapLatLng(51.449774, 7.269035),
      MapLatLng(51.450048, 7.270025),
      MapLatLng(51.449316, 7.270602),
      MapLatLng(51.449285, 7.270929),
      MapLatLng(51.449043, 7.271343),
      MapLatLng(51.448458, 7.271709),
      MapLatLng(51.447866, 7.270125),
      MapLatLng(51.448446, 7.269643),
      MapLatLng(51.448152, 7.268787),
      MapLatLng(51.448573, 7.268421),
      MapLatLng(51.448290, 7.267784),
      MapLatLng(51.449190, 7.267178),
      MapLatLng(51.449708, 7.266626),
    ];

    plannedRoutes = <List<MapLatLng>>[polyline];
    walkedRoutes = <List<MapLatLng>>[];
    _controller = MapTileLayerController();
    _zoomPanBehavior = _CustomZoomPanBehavior()..onTap = setMarker;
    _zoomPanBehavior.maxZoomLevel = 20;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SfMaps(
        layers: [
          MapTileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            //initialMarkersCount: 3,
            /*markerBuilder: (BuildContext context, int index) {
              return MapMarker(
                latitude: plannedRoutes.first[index].latitude,
                longitude: plannedRoutes.first[index].longitude,
                iconColor: Colors.blue,
                iconType: MapIconType.diamond,
              );
            },*/
            controller: _controller,
            sublayers: [
              MapPolylineLayer(
                polylines: List<MapPolyline>.generate(
                  plannedRoutes.length,
                  (int index) {
                    return MapPolyline(
                      points: plannedRoutes[index],
                      color: Colors.red,
                    );
                  },
                ).toSet(),
              ),
              MapPolylineLayer(
                polylines: List<MapPolyline>.generate(
                  walkedRoutes.length,
                  (int index) {
                    return MapPolyline(
                      points: walkedRoutes[index],
                      color: Colors.blue,
                    );
                  },
                ).toSet(),
              ),
            ],
            initialZoomLevel: 14,
            initialFocalLatLng: MapLatLng(51.448016, 7.271185),
            zoomPanBehavior: _zoomPanBehavior,
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 31),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: () {
                  List<MapLatLng> tmpPoly = [];
                  if (isChecked) {
                    plannedRoutes.add(tmpPoly);
                  } else {
                    walkedRoutes.add(tmpPoly);
                  }
                  setState(() {});
                },
                child: const Icon(Icons.linear_scale),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  //setState(() {
                  gps();
                  //});
                },
                child: const Icon(Icons.location_on),
              )),
          Padding(
            padding: EdgeInsets.only(left: 31, top: 32),
            child: Align(
                alignment: Alignment.topLeft,
                child: Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                )),
          )
        ],
      ),
    ));
  }

  gps() async {
    //check and request permissions, error prevention
    bool serviceEnabled;
    LocationPermission permission;
    Position pos;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // once here, permissions are as needed, so locaction is set

    pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (walkedRoutes.isEmpty) {
      List<MapLatLng> tmpPoly = [];
      walkedRoutes.add(tmpPoly);
    }
    walkedRoutes.last.add(MapLatLng(pos.latitude, pos.longitude));
  }

  void setMarker(Offset position) {
    if (isChecked) {
      MapLatLng tmpPos = _controller.pixelToLatLng(position);

      plannedRoutes.last.add(tmpPos);
    }
  }
}

class PolylineModel {
  PolylineModel(this.points);
  final List<MapLatLng> points;
}

class _CustomZoomPanBehavior extends MapZoomPanBehavior {
  _CustomZoomPanBehavior();
  late MapTapCallback onTap;

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerUpEvent) {
      onTap(event.localPosition);
    }
    super.handleEvent(event);
  }
}

typedef MapTapCallback = void Function(Offset position);
