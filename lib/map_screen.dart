import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(52.40990779970782, 16.923019795446486),
    zoom: 14.4746,
  );

  List<PlaceModel> placeList = [
    PlaceModel(
        "Avenida",
        "Matyi 2",
        "description",
        "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&w=600",
        const LatLng(52.401382793293635, 16.917033646392834)),
    PlaceModel(
        "MultiKino",
        "Królowej Jadwigi 51, 61-872 Poznań",
        "description",
        "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&w=600",
        const LatLng(52.39946684742279, 16.929070297780353)),
    PlaceModel(
        "Lidl",
        "Macieja Palacza 18, 60-241 Poznań",
        "description",
        "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&w=600",
        const LatLng(52.387906905360474, 16.887605438851036)),
    PlaceModel(
        "McDonald",
        "Hetmańska 100, 60-219 Poznań",
        "description",
        "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&w=600",
        const LatLng(52.383879533988335, 16.916870422570543)),
  ];
  List<Marker> allMalkers = [];
  var _pageController = PageController();
  @override
  void initState() {
    super.initState();
    for (var element in placeList) {
      allMalkers.add(Marker(
          markerId: MarkerId(element.placeName),
          draggable: false,
          infoWindow:
              InfoWindow(title: element.placeName, snippet: element.address),
          position: element.locationCoords));
    }
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8);
  }

  _placeList(index) {
    return InkWell(
      onTap: () {
        _goToThePlace(placeList[index].locationCoords);
      },
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 5.0,
          ),
          height: 120.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(0.0, 4.0),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  height: 120.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(placeList[index].image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          placeList[index].placeName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          placeList[index].address,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          placeList[index].description,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _initialPosition,
                markers: Set.from(allMalkers),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0.0, 4.0),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.search),
                    ),
                    const Expanded(
                      child: Center(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(right: 5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Colors.black),
                      child: const Icon(
                        Icons.tune,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10.0,
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return _placeList(index);
                  },
                  controller: _pageController,
                  itemCount: placeList.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _goToThePlace(LatLng locationCoords) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 192.8334901395799,
            target: locationCoords,
            tilt: 59.440717697143555,
            zoom: 19.151926040649414)));
  }
}

class PlaceModel {
  String placeName;
  String address;
  String description;
  String image;
  LatLng locationCoords;
  PlaceModel(this.placeName, this.address, this.description, this.image,
      this.locationCoords);
}
