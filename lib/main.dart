import 'dart:async';
import 'dart:convert';
//import 'dart:html'; // šitas taisa error

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled4/DataTableMySqlDemo/Employee.dart';
import 'package:untitled4/location_service.dart';
import 'package:untitled4/logic-models/mysql.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custom_marker/marker_icon.dart';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';

import 'DataTableMySqlDemo/DataTableDemo.dart';
import 'DataTableMySqlDemo/Services.dart';
import 'DataTableMySqlDemo/Employee.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// void main() => runApp(MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  String buttonName = 'Start Charging';
  int buttonIndex = 0;
  int currentIndex = 0;
  bool _isClicked = false;
  Duration duration = Duration();
  Timer? timer;

  var station_code_n_1 = '0';
  var station_code_n_2 = '0';
  var station_code_n_3 = '0';

  var db = new Mysql();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // static final CameraPosition _rigaLocation = CameraPosition(
  //   target: LatLng(56.9677, 24.1056),
  //   zoom: 14.4746,
  // );

/*
  static final Marker _kGooglePlexMarker = Marker(
    markerId: MarkerId('_kGooglePlex'),
    infoWindow: InfoWindow(title: 'GooglePlex'),
    //icon: BitmapDescriptor.defaultMarker,
    //ImageConfiguration configuration = createLocalImageConfiguration(context);
    //icon: BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, 'images/IconChrg4.png'),
    icon: customMarker,
    position: LatLng(37.42796133580664, -122.085749655962),
  );
  static final Marker _kLakeMarker = Marker(
    markerId: MarkerId('_kLakeMarker'),
    infoWindow: InfoWindow(title: 'LakeMarker'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    position: LatLng(37.43296265331129, -122.08832357078792),
  );
*/

  // CustomInfoWindowController _customInfoWindowController =
  //     CustomInfoWindowController(); // custom infowindow

  Set<Marker> markers = Set(); //markers for google map

  LatLng startLocation = LatLng(37.42796131280664, -122.085749655962);
  LatLng endLocation = LatLng(37.42126133580664, -122.085749655962);
  LatLng carLocation = LatLng(37.42796133581264, -122.085749655962);

  /* // šādi varētu datubāzes stringus pārvērst par LatLng positioniem.
     // bet laiakm ne īsti, jo tā apt met error
 String lokLat = '37.42796131280664';
 String lokLNG = '-122.085749655962';

 LatLng lokacija = LatLng(double.parse(lokLat), double.parse(lokLNG));

  void positionDecoder() {
    Services.getUseSimple('100').then((value) {
      value[18];
    });
  }

  void positionFunction(var i) {
    for (; i < 3; i++) {
      //LatLng endLocation = LatLng();
    }
  }
*/
  // LatLng endLocation0 = LatLng(37.42796131280664, -122.085749655962);
  // LatLng endLocation1 = LatLng(37.42126133580664, -122.085749655962);
  // LatLng endLocation2 = LatLng(37.42796133123456, -122.085749612345);

  /*
  LatLng RigaLocation1 = LatLng(56.9677, 24.1056);
  LatLng RigaLocation2 = LatLng(56.961931, 24.117156);
  LatLng RigaLocation3 = LatLng(56.960782, 24.123564);
  LatLng RigaLocation4 = LatLng(56.947536, 24.123024);
  LatLng RigaLocation5 = LatLng(56.951005, 24.129468);
  LatLng RigaLocation6 = LatLng(56.940725, 24.095979);
  LatLng RigaLocation7 = LatLng(56.924684, 23.982058);
  LatLng RigaLocation8 = LatLng(56.983907, 24.203974);
  LatLng RigaLocation9 = LatLng(56.953844, 24.256247);
  LatLng RigaLocation10 = LatLng(56.923962, 24.176956);
*/

  String infTitle = 'Nosaukums';
  //String infSnip = 'joloberns';
  String infSnip = 'nosuakums';

  tips() {
    String data = 'nekas';
    Services.getUseSimple('100').then((value) {
      data = value;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();

    String data = 'nekas';
    Services.getUseSimple('100').then((value) {
      data = value;
    });
    // for (var i = 0; i < 3; i++) {
    //   if (i == 0) {
    //     addMarkers(endLocation0);
    //   } else if (i == 1) {
    //     addMarkers(endLocation1);
    //   } else if (i == 2) {
    //     addMarkers(endLocation2);
    //   }
    // }
    addMarkers(endLocation, infTitle);
    //addMarkers(positionVar, infWinTitle, infWinSnip)

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //SharedPrefs().deleteCharging;
      pageChargeStartState(buttonIndex);
    });

    startTimer();
    reset();

    //_setMarker(LatLng(37.42796133580664, -122.085749655962));
  }

/*
  countAllFunction() {
    int amount = 0;
    Services.countAll().then((value) {
      //print('countAll: ' + value[18]);
      amount = int.parse(value[18]);
    });
    var stationLocationList = <double>[];

    for (int i = 0; i < amount; i++) {
      Services.getLocation(i.toString()).then((value) {
        stationLocationList.add(double.parse(value));
      });
    }
    print(stationLocationList);
  }

  stationList() {
    late List stationLoca;
  }
  */

  addMarkers(LatLng positionVar, String infWinTitle) async {
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/IconChrg4.png",
    );

    Uint8List markerIcon =
        await getBytesFromAsset('assets/images/IconChrg4.png', 120);

    String dataSnippet = 'nekas';
    Services.getUseSimple('100').then((value) {
      print('value: ' + value);
      dataSnippet = value;

      print('dataSnippet: ' + dataSnippet);
      markers.add(Marker(
        //add start location marker
        markerId: MarkerId(positionVar.toString()),
        position: positionVar, //position of marker

        //rotation: -10,
        infoWindow: InfoWindow(
          //popup info
          title: infWinTitle,
          //snippet: infWinSnip,
          snippet: dataSnippet,
          onTap: () {
            currentIndex = 1;
          },
        ),
        // onTap: () {
        //   //setState(() {});
        //   //showAlertDialog(context, 'pickCharger');
        //   //currentIndex = 1;
        // },

        //icon: markerbitmap, //Icon for Marker
        icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
      ));
    });

    if (dataSnippet == 'nekas') {
      dataSnippet = 'kkads murgs';
    }

    // markers.add(Marker(
    //   //add start location marker
    //   markerId: MarkerId(positionVar.toString()),
    //   position: positionVar, //position of marker

    //   //rotation: -10,
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: infWinTitle,
    //     //snippet: infWinSnip,
    //     snippet: dataSnippet,
    //     onTap: () {
    //       currentIndex = 1;
    //     },
    //   ),
    //   // onTap: () {
    //   //   //setState(() {});
    //   //   //showAlertDialog(context, 'pickCharger');
    //   //   //currentIndex = 1;
    //   // },

    //   //icon: markerbitmap, //Icon for Marker
    //   icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
    // ));

    setState(() {
      //refresh UI
    });
  }

//   addMarkers() async {
//     BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(),
//       "assets/images/IconChrg4.png",
//     );

//     Uint8List markerIcon =
//         await getBytesFromAsset('assets/images/IconChrg4.png', 120);

//     markers.add(Marker(
//       //add start location marker
//       markerId: MarkerId(startLocation.toString()),
//       position: startLocation, //position of marker
//       // infoWindow: InfoWindow(
//       //   //popup info
//       //   title: 'Starting Point ',
//       //   snippet: 'Info texts',
//       // ),

//       //icon: markerbitmap, //Icon for Marker
//       icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
//     ));
// /*
//     markers.add(Marker(
//       //add start location marker
//       markerId: MarkerId(startLocation.toString()),
//       position: RigaLocation1, //position of marker
//       infoWindow: InfoWindow(
//         //popup info
//         title: 'Riga Point ',
//         snippet: 'Info texts',
//       ),

//       //icon: markerbitmap, //Icon for Marker
//       icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
//     ));
//     markers.add(Marker(
//       //add start location marker
//       markerId: MarkerId(startLocation.toString()),
//       position: RigaLocation2, //position of marker
//       infoWindow: InfoWindow(
//         //popup info
//         title: 'Riga Point ',
//         snippet: 'Info texts',
//       ),

//       //icon: markerbitmap, //Icon for Marker
//       icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
//     ));
//     markers.add(Marker(
//       //add start location marker
//       markerId: MarkerId(startLocation.toString()),
//       position: RigaLocation3, //position of marker
//       infoWindow: InfoWindow(
//         //popup info
//         title: 'Riga Point ',
//         snippet: 'Info texts',
//       ),

//       //icon: markerbitmap, //Icon for Marker
//       icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
//     ));
//     markers.add(Marker(
//       //add start location marker
//       markerId: MarkerId(startLocation.toString()),
//       position: RigaLocation4, //position of marker
//       infoWindow: InfoWindow(
//         //popup info
//         title: 'Riga Point ',
//         snippet: 'Info texts',
//       ),

//       //icon: markerbitmap, //Icon for Marker
//       icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
//     ));
//     markers.add(Marker(
//       //add start location marker
//       markerId: MarkerId(startLocation.toString()),
//       position: RigaLocation5, //position of marker
//       infoWindow: InfoWindow(
//         //popup info
//         title: 'Riga Point ',
//         snippet: 'Info texts',
//       ),

//       //icon: markerbitmap, //Icon for Marker
//       icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
//     ));
//     markers.add(Marker(
//       //add start location marker
//       markerId: MarkerId(startLocation.toString()),
//       position: RigaLocation6, //position of marker
//       infoWindow: InfoWindow(
//         //popup info
//         title: 'Riga Point ',
//         snippet: 'Info texts',
//       ),

//       //icon: markerbitmap, //Icon for Marker
//       icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
//     ));
//     markers.add(Marker(
//       //add start location marker
//       markerId: MarkerId(startLocation.toString()),
//       position: RigaLocation7, //position of marker
//       infoWindow: InfoWindow(
//         //popup info
//         title: 'Riga Point ',
//         snippet: 'Info texts',
//       ),

//       //icon: markerbitmap, //Icon for Marker
//       icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
//     ));
//     markers.add(Marker(
//       //add start location marker
//       markerId: MarkerId(startLocation.toString()),
//       position: RigaLocation8, //position of marker
//       infoWindow: InfoWindow(
//         //popup info
//         title: 'Riga Point ',
//         snippet: 'Info texts',
//       ),

//       //icon: markerbitmap, //Icon for Marker
//       icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
//     ));
//     markers.add(Marker(
//       //add start location marker
//       markerId: MarkerId(startLocation.toString()),
//       position: RigaLocation9, //position of marker
//       infoWindow: InfoWindow(
//         //popup info
//         title: 'Riga Point ',
//         snippet: 'Info texts',
//       ),

//       //icon: markerbitmap, //Icon for Marker
//       icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
//     ));
//     markers.add(Marker(
//       //add start location marker
//       markerId: MarkerId(startLocation.toString()),
//       position: RigaLocation10, //position of marker
//       infoWindow: InfoWindow(
//         //popup info
//         title: 'Riga Point ',
//         snippet: 'Info texts',
//       ),

//       //icon: markerbitmap, //Icon for Marker
//       icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
//     ));
// */
//     markers.add(Marker(
//       //add start location marker
//       markerId: MarkerId(endLocation.toString()),
//       position: endLocation, //position of marker

//       //rotation: -10,
//       infoWindow: InfoWindow(
//         //popup info
//         title: 'Mezmalas iela 3',
//         snippet: 'available, 50kw, type2, suns, suns,suns',
//         onTap: () {
//           currentIndex = 1;
//         },

//       ),
//       // onTap: () {
//       //   //setState(() {});
//       //   //showAlertDialog(context, 'pickCharger');
//       //   //currentIndex = 1;
//       // },

//       //icon: markerbitmap, //Icon for Marker
//       icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
//     ));

//     String imgurl = "https://www.fluttercampus.com/img/car.png";
//     Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl)).load(imgurl))
//         .buffer
//         .asUint8List();

//     markers.add(Marker(
//       //add start location marker
//       markerId: MarkerId(carLocation.toString()),
//       position: carLocation, //position of marker

//       infoWindow: InfoWindow(
//         //popup info
//         title: 'Car Point ',
//         snippet: 'Car Marker',
//       ),
//       icon: BitmapDescriptor.fromBytes(bytes), //Icon for Marker
//     ));

//     setState(() {
//       //refresh UI
//     });
//   }

  void addTime() {
    final addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void reset() {
    setState(() => duration = Duration());
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
    print('sāk start taimeris');
  }

  pageChargeStartState(int buttonState) async {
    if (SharedPrefs().charging.isNotEmpty) {
      buttonIndex = 1;
      setState(() {});
    } else {
      buttonIndex = 0;
      setState(() {});
    }
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('marker'),
          position: point,
          //icon: BitmapDescriptor.defaultMarker,
          //icon: customMarker,
        ),
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent,
      ),
    );
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  var dataUse;
  var _dataUse;
  var trisViena;

/*
  _getUse(String id_no) {
    Services.getUse(id_no).then((use) {
      setState(() {
        _dataUse = use;
      });
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body:
          //future: BddController().getData();
          Center(
              child: currentIndex == 0
                  ? Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              /*
                        Expanded(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _originController,
                                decoration:
                                    InputDecoration(hintText: ' Origin'),
                                onChanged: (value) {
                                  print(value);
                                },
                              ),
                              TextFormField(
                                controller: _destinationController,
                                decoration:
                                    InputDecoration(hintText: ' Destination'),
                                onChanged: (value) {
                                  print(value);
                                },
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            var directions =
                                await LocationService().getDirections(
                              _originController.text,
                              _destinationController.text,
                            );
                            _goToPlace(
                              directions['start_location']['lat'],
                              directions['start_location']['lng'],
                              directions['bounds_ne'],
                              directions['bounds_sw'],
                            );

                            _setPolyline(directions['polyline_decoded']);
                          },
                          icon: Icon(Icons.search),
                        ),*/
                            ],
                          ),
                          Expanded(
                            child: GoogleMap(
                              mapType: MapType.normal,
                              //markers: _markers,
                              markers: markers,
                              polygons: _polygons,
                              polylines: _polylines,
                              initialCameraPosition: _kGooglePlex,
                              //initialCameraPosition: _rigaLocation,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                              /*
                        onTap: (point) {
                          setState(() {
                            polygonLatLngs.add(point);
                            _setPolygon();
                          });
                        },*/
                            ),
                          ),
                        ],
                      ),
                    )
                  : currentIndex == 1
                      ? Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buttonIndex == 0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          height: 68,
                                          width: 64,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              if (value.length == 1) {
                                                station_code_n_1 = value;
                                                print(station_code_n_1);
                                                FocusScope.of(context)
                                                    .nextFocus();
                                              }
                                            },
                                            onSaved: (pin1) {
                                              //station_code_n_1 = pin1;
                                              //print(station_code_n_1);
                                            },
                                            decoration: const InputDecoration(
                                                hintText: "0"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  1),
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 68,
                                          width: 64,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              if (value.length == 1) {
                                                station_code_n_2 = value;
                                                print(station_code_n_2);
                                                FocusScope.of(context)
                                                    .nextFocus();
                                              }
                                            },
                                            onSaved: (pin1) {},
                                            decoration: const InputDecoration(
                                                hintText: "0"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  1),
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 68,
                                          width: 64,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              if (value.length == 1) {
                                                station_code_n_3 = value;
                                                print(station_code_n_3);
                                                FocusScope.of(context)
                                                    .nextFocus();
                                              }
                                            },
                                            onSaved: (pin1) {},
                                            decoration: const InputDecoration(
                                                hintText: "0"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  1),
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Station: ' +
                                                station_code_n_1 +
                                                station_code_n_2 +
                                                station_code_n_3,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        buildTime(),
                                      ],
                                    ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                                onPressed: () {
                                  trisViena = station_code_n_1 +
                                      station_code_n_2 +
                                      station_code_n_3;
                                  SharedPrefs().chargingStation = trisViena;
                                  if (trisViena == '000' || trisViena == '0') {
                                    print('trisVienā NO: ' + trisViena);
                                    //DialogExample();
                                    print('buttonIndex: ' +
                                        buttonIndex.toString());
                                    showAlertDialog(context, 'enterCharger');
                                  } else {
                                    print('trisVienā Yes: ' + trisViena);
                                    if (buttonIndex == 0) {
                                      buttonIndex = 1;
                                      Services.getUseSimple(trisViena)
                                          .then((value) {
                                        if (value == '[{"in_use":"N"}]') {
                                          print('varam lādēt');
                                          print('buttonIndex: ' +
                                              buttonIndex.toString());
                                          //buttonIndex = 1;
                                          Services.updateUse(trisViena, 'Y');
                                          SharedPrefs().charging = 'Y';
                                          //pieliktais
                                          Services.countAll().then((value) {
                                            print('countAll: ' + value[18]);
                                          });
                                          print('count all functions: ');
                                          //countAllFunction();
                                        } else {
                                          print('nevaram lādēt');
                                          print('buttonIndex: ' +
                                              buttonIndex.toString());
                                          showAlertDialog(
                                              context, 'busyCharger');
                                        }
                                      });
                                      reset();
                                    } else {
                                      buttonIndex = 0;
                                      Services.getUseSimple(trisViena)
                                          .then((value) {
                                        if (value == '[{"in_use":"Y"}]') {
                                          print('varam beigt lādēt');
                                          print('buttonIndex: ' +
                                              buttonIndex.toString());
                                          //buttonIndex = 0;
                                          Services.updateUse(trisViena, 'N');
                                          //SharedPrefs().charging = 'N';
                                          SharedPrefs().deleteCharging;
                                          SharedPrefs().deleteCharging();
                                          Services.calcPrice('14')
                                              .then((value) {
                                            print('calcPrice: ' + value);
                                          });
                                          reset();
                                        } else {
                                          print('nevaram bigt lādēt');
                                          Services.calcPrice('14')
                                              .then((value) {
                                            print('calcPrice: ' + value);
                                          });
                                          SharedPrefs().deleteCharging;
                                          print('buttonIndex: ' +
                                              buttonIndex.toString());
                                        }
                                      });
                                    }
                                    print('buttonIndex: ' +
                                        buttonIndex.toString());
                                    setState(() {
                                      if (buttonIndex == 0) {
                                        buttonName = 'Start Charging';
                                      }
                                      if (buttonIndex == 1) {
                                        buttonName = 'Stop Charging';
                                      }
                                    });
                                  }
                                },
                                child: Text(buttonName),
                              )
                            ],
                          ),
                        )
                      : ListView(
                          children: [
                            buildAccountOption(context, "Profile", 1),
                            buildAccountOption(context, "Payment", 2),
                            buildAccountOption(context, "Help 24/7", 3),
                            buildAccountOption(context, "Tutorial", 4),
                            buildAccountOption(context, "FAQ", 5),
                            /*
                  ButtonTheme(
                    // jaieliekt TextButtonTheme jo jaunaķs
                    minWidth: 200.0,
                    height: 100.0,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const SecondPage();
                            },
                          ),
                        );
                      },
                      child: Text('Next Page'),
                    ),
                  ),*/
                          ],
                        )),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Map',
            icon: Icon(Icons.map),
          ),
          BottomNavigationBarItem(
            label: 'Charging',
            icon: Icon(Icons.power),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    print('sāk build taimeris');

    // return Text(
    //   '$minutes:$seconds',
    //   style: TextStyle(fontSize: 50),
    // );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: minutes, header: 'Minutes'),
        const SizedBox(width: 8),
        buildTimeCard(time: seconds, header: 'Seconds'),
      ],
    );
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 72,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(header),
        ],
      );

  // šeit gesture:
  GestureDetector buildAccountOption(
      BuildContext context, String title, int pageNext) {
    return GestureDetector(
      onTap: () {
        pageNext == 1
            ? Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return SecondPageOne();
                  },
                ),
              )
            : pageNext == 2
                ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        //return const SecondPageTwo();
                        return SecondPageTwo();
                      },
                    ),
                  )
                : pageNext == 3
                    ? Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const SecondPageHelp();
                          },
                        ),
                      )
                    : pageNext == 4
                        ? Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                //return const SecondPageFour();
                                return DataTableDemo();
                              },
                            ),
                          )
                        : Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const SecondPageFAQ();
                              },
                            ),
                          );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _goToPlace(
    //Map<String, dynamic> place,
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    //final double lat = place['geometry']['location']['lat'];
    //final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          25),
    );

    //_setMarker(LatLng(lat, lng));
    _setMarker(LatLng(37.42796133580664, -122.085749655962));
  }
}

class SecondPageOne extends StatefulWidget {
  SecondPageOne({super.key});

  @override
  State<SecondPageOne> createState() => _SecondPageOneState();
}

class _SecondPageOneState extends State<SecondPageOne> {
  int buttonIndex = 0;

  //String buttonNameLog = 'Save email';
  String buttonNameSign = 'Sava email';

  String emailSaved = 'roberts.eihe@gmail.com';

  // TextEditingController controller = new TextEditingController();
  // late SharedPreferences prefs;
  // String name = "";

  // save() async {
  //   prefs = await SharedPreferences.getInstance();
  //   prefs.setString("username", controller.text.toString());
  // }

  // retrieve() async {
  //   prefs = await SharedPreferences.getInstance();
  //   name = prefs.getString("username") ?? '';
  //   setState(() {});
  // }

  // delete() async {
  //   prefs = await SharedPreferences.getInstance();
  //   prefs.remove("username");
  //   name = "";
  //   setState(() {});
  // }

  // pageStartState(int buttonState) async {
  //   prefs = await SharedPreferences.getInstance();
  //   name = prefs.getString("username") ?? '';
  //   if (name.length > 1) {
  //     buttonIndex = 1;
  //   } else {
  //     buttonIndex = 0;
  //   }
  // }

  pageStartState(int buttonState) async {
    if (SharedPrefs().username.length > 1) {
      buttonIndex = 1;
      setState(() {});
    } else {
      buttonIndex = 0;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    //pageStartState(buttonIndex);
    //retrieve();
    //SharedPrefs().retrieve;
    //SharedPrefs().username;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageStartState(buttonIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page One'),
      ),
      body: Center(
        child: Container(
          //color: Colors.amber,
          width: 300,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 200,
                  //color: Colors.deepPurple[200],
                  child: Icon(
                    Icons.account_circle,
                    size: 90,
                    color: Colors.purple,
                  ),
                ),
              ),
              buttonIndex == 0
                  ? Column(children: [
                      SizedBox(
                        height: 50,
                        width: 250,
                        child: TextFormField(
                          //controller: controller,

                          onChanged: (value) {
                            emailSaved = value;
                          },
                          onSaved: (pin1) {},
                          decoration: const InputDecoration(
                            hintText: "  email",
                            border: OutlineInputBorder(),
                          ),
                          style: Theme.of(context).textTheme.headline6,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.left,

                          //inputFormatters: [
                          //LengthLimitingTextInputFormatter(19),
                          //new CustomInputFormatterSpace(),
                          //],
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 166, 59, 185))),
                        onPressed: () async {
                          if (buttonIndex == 0) {
                            buttonIndex = 1;
                            // save();
                            // await retrieve();
                            print('SharedPrefs username: ');

                            SharedPrefs().username = emailSaved;

                            print(await SharedPrefs().username);
                          } else {
                            buttonIndex = 0;
                            //delete();
                          }
                          setState(() {
                            if (buttonIndex == 0) {
                              buttonNameSign = 'Save email';
                            }
                            if (buttonIndex == 1) {
                              buttonNameSign = 'Delete email';
                            }
                          });
                          // print(buttonIndex);
                        },
                        child: Text(buttonNameSign),
                      ),
                    ])
                  //   : Text('roberts.eihe'),
                  : Column(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 250,
                          child: Text(
                            //name,
                            SharedPrefs().username,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 166, 59, 185))),
                              onPressed: () async {
                                if (buttonIndex == 0) {
                                  buttonIndex = 1;
                                  // save();
                                  // await retrieve();
                                  SharedPrefs().username = emailSaved;
                                  SharedPrefs().username;
                                  //await UserSimplePreferences().setUsername(emailSaved);
                                  //await UserSimplePreferences().getUsername().toString();
                                } else {
                                  buttonIndex = 0;
                                  //delete();
                                }
                                setState(() {
                                  if (buttonIndex == 0) {
                                    buttonNameSign = 'Save email';
                                  }
                                  if (buttonIndex == 1) {
                                    buttonNameSign = 'Delete';
                                  }
                                });
                                // print(buttonIndex);
                              },
                              child: Text(buttonNameSign),
                            ),
                            OutlinedButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 166, 59, 185),
                                ),
                              ),
                              onPressed: () {
                                if (buttonIndex == 0) {
                                  buttonIndex = 1;
                                } else {
                                  buttonIndex = 0;
                                }
                                // setState(() {
                                //   if (buttonIndex == 0) {
                                //     buttonNameSign = 'change password';
                                //   }
                                //   if (buttonIndex == 1) {
                                //     buttonNameSign = 'change password';
                                //   }
                                // });
                                // print(buttonIndex);
                              },
                              child: Text('edit email'),
                            ),
                          ],
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPageTwo extends StatefulWidget {
  @override
  State<SecondPageTwo> createState() => _SecondPageTwoState();
}

class _SecondPageTwoState extends State<SecondPageTwo> {
  // const SecondPageTwo({super.key});
  var cardNumber;
  late String cardHolder;
  var cardMMYY;
  var cardCVC;
  String buttonName = 'Save card';
  int buttonIndex = 0;
  late String mask;

  cardHolderShortName(String fullName) {
    String shortName;
    int endCount;
    int startCount;

    startCount = fullName.indexOf(' ');
    print('index of: ' + startCount.toString());

    endCount = startCount + 4;
    print('endCount: ' + endCount.toString());
    print('fullName:' + fullName.length.toString());
    if (endCount == fullName.length) {
      shortName = fullName;
      print('izvēlas ar ...');
    } else {
      shortName = fullName.substring(0, endCount) + ' ...';
      print('izvēlas BEZ ...');
    }

    return shortName;
  }

  pageStartState(int buttonState) async {
    if (SharedPrefs().paymentCard != '' &&
        SharedPrefs().paymentCard != ' ' &&
        SharedPrefs().paymentCard.isNotEmpty) {
      buttonIndex = 1;
      setState(() {});
    } else {
      buttonIndex = 0;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageStartState(buttonIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Two'),
      ),
      body: Container(
        child: Column(
          children: [
            buttonIndex == 0
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 240,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 19) {
                                  cardNumber = value;
                                  print(cardNumber);
                                  FocusScope.of(context).nextFocus();
                                }
                                if (value.length == 0) {
                                  cardNumber = value;
                                  print(cardNumber);
                                }
                              },
                              onSaved: (pin1) {},
                              decoration: const InputDecoration(
                                  hintText: "  Payment Card Number"),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.left,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(19),
                                FilteringTextInputFormatter.digitsOnly,
                                new CustomInputFormatterSpace(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                        width: 240,
                        child: TextFormField(
                          onChanged: (value) {
                            cardHolder = value;
                            print(cardHolder);
                          },
                          onSaved: (pin1) {},
                          decoration: const InputDecoration(
                              hintText: "  Payment Card Holder"),
                          style: Theme.of(context).textTheme.headline6,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.left,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(24),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 110,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 5) {
                                  cardMMYY = value;
                                  print(cardMMYY);
                                  FocusScope.of(context).nextFocus();
                                }
                                if (value.length == 0) {
                                  cardMMYY = value;
                                  print(cardMMYY);
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              onSaved: (pin1) {},
                              decoration:
                                  const InputDecoration(hintText: "MM/YY"),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(5),
                                FilteringTextInputFormatter.digitsOnly,
                                new CustomInputFormatterSlash()
                              ],
                            ),
                          ),
                          Text('      '),
                          SizedBox(
                            height: 50,
                            width: 110,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 3) {
                                  cardCVC = value;
                                  print(cardCVC);
                                  FocusScope.of(context).nextFocus();
                                }
                                if (value.length == 0) {
                                  cardCVC = value;
                                  print(cardCVC);
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              onSaved: (pin1) {},
                              decoration:
                                  const InputDecoration(hintText: "CVC"),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          /*          
             Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return con;
                  },
                ),
              );
         */
                          //buttonIndex = 0;
                          print(buttonIndex);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                // '**** ' +
                                //     cardNumber
                                //         .substring(cardNumber.length - 5) +
                                //     '  ' +
                                //     cardHolderShortName(cardHolder),

                                '**** ' + SharedPrefs().paymentCard,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
            ElevatedButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 166, 59, 185))),
              onPressed: () {
                if (buttonIndex == 0) {
                  buttonIndex = 1;
                  // Services.updatePaymentCard(
                  //     '1', cardNumber, cardHolder, cardMMYY, cardCVC);
                  SharedPrefs().paymentCard =
                      cardNumber.substring(cardNumber.length - 5) +
                          '  ' +
                          cardHolderShortName(cardHolder);
                } else {
                  buttonIndex = 0;
                  // Services.updDeletePaymentCard('1');
                  SharedPrefs().deletePaymentCard();
                }
                setState(() {
                  if (buttonIndex == 0) {
                    buttonName = 'Save card';
                  }
                  if (buttonIndex == 1) {
                    buttonName = 'Delete card';
                  }
                });
                print(buttonIndex);
              },
              child: Text(buttonName),
            )
          ],
        ),
      ),
    );
  }
}

class SecondPageThree extends StatelessWidget {
  const SecondPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Three'),
      ),
      body: Container(
        child: Column(
          children: [
            buildAccountOption(context, "Help 24/7", 1),
            buildAccountOption(context, "Buiness contacts", 2),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOption(
      BuildContext context, String title, int pageNext) {
    return GestureDetector(
      onTap: () {
        pageNext == 1
            ? Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const SecondPageHelp();
                  },
                ),
              )
            : Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const SecondPageBusiness();
                  },
                ),
              );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}

class SecondPageFour extends StatelessWidget {
  const SecondPageFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Four'),
      ),
      body: Container(),
    );
  }
}

class SecondPageHelp extends StatelessWidget {
  const SecondPageHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Help'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('24 / 7'),
            Row(
              children: [
                Icon(Icons.call,
                    size: 50, color: Color.fromARGB(255, 166, 59, 185)),
                TextButton(
                  child: Text(
                    '+371 26828334',
                    style: TextStyle(fontSize: 25),
                  ),
                  onPressed: () async {
                    await launch("tel:+37126828334");

                    // final Uri launchUri = Uri(
                    //   scheme: 'tel',
                    //   path: "+37126828334",
                    // );
                    // if (await canLaunch(launchUri.toString())) {
                    //   await launch(launchUri.toString());
                    // } else {
                    //   print("the action is not supported. (No Phone app)");
                    // }
                  },
                )
              ],
            ),
            Row(
              children: [
                Icon(Icons.mail_outlined,
                    size: 50, color: Color.fromARGB(255, 166, 59, 185)),
                TextButton(
                  child: Text(
                    'roberts.eihe@gmail.com',
                    style: TextStyle(fontSize: 25),
                  ),
                  onPressed: () async {
                    String email = 'roberts.eihe@gmail.com';
                    String subject = 'purel Support';
                    //String body = 'Hit the like button';

                    String? encodeQueryParameters(Map<String, String> params) {
                      return params.entries
                          .map((MapEntry<String, String> e) =>
                              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                          .join('&');
                    }

                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: email,
                      query: encodeQueryParameters(<String, String>{
                        'subject': subject, /*'body': body*/
                      }),
                    );
                    // if (await canLaunch(emailUri.toString())) {
                    launch(emailUri.toString());
                    // } else {
                    //   print('the action is not supported (No emial app)');
                    // }
                  },
                )
              ],
            ),
          ],
        ),
      ),
      // ListView(
      //   physics: BouncingScrollPhysics(),
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Container(
      //         height: 180,
      //         color: Colors.deepPurple[200],
      //         child: Icon(
      //           Icons.call,
      //           size: 80,
      //           color: Colors.purple,
      //         ),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Container(
      //         height: 180,
      //         color: Colors.deepPurple[200],
      //         child: Icon(
      //           Icons.chat,
      //           size: 80,
      //           color: Colors.purple,
      //         ),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Container(
      //         height: 180,
      //         color: Colors.deepPurple[200],
      //         child: Icon(
      //           Icons.mail_outline,
      //           size: 80,
      //           color: Colors.purple,
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class SecondPageBusiness extends StatelessWidget {
  const SecondPageBusiness({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Business'),
      ),
      body: Container(),
    );
  }
}

class SecondPageFAQ extends StatelessWidget {
  const SecondPageFAQ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page FAQ'),
      ),
      body: Container(),
    );
  }
}

showAlertDialog(BuildContext context, String alertCase) {
  int currentIndex = 0;
  // Create button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  Widget chrgButton = TextButton(
    child: Text("index = 1"),
    onPressed: () {
      //currentIndex = 1;
      //Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return SecondPageOne();
          },
        ),
      );
      ;
    },
  );
  Widget closeButton = TextButton(
    child: Text("Close"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog universalAlert = AlertDialog(
    title: Text("Warning!"),
    content: Text("Something went wrong, try again!"),
    actions: [
      okButton,
    ],
  );
  AlertDialog busyCharger = AlertDialog(
    title: Text("Charger Occupied"),
    content: Text(
        "This charger is occupied. Check if code entered corrrectly. Otherwise, look for another charger or another charging station."),
    actions: [
      okButton,
    ],
  );
  AlertDialog enterCharger = AlertDialog(
    title: Text("Enter Charger Code"),
    content: Text(
        "Enter three digit charger code. Look for the code next to the connector cable."),
    actions: [
      okButton,
    ],
  );

  AlertDialog pickCharger = AlertDialog(
    title: Text("End point"),
    //content: Text("Pick a charger! okay, I will pick"),
    content: SizedBox(
      width: 200,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(),
          okButton,
          Divider(),
          chrgButton,
          Divider(),
          closeButton
        ],
      ),
    ),
    // actions: [
    //   chrgButton,
    // ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      if (alertCase == 'busyCharger') {
        return busyCharger;
      } else if (alertCase == 'enterCharger') {
        return enterCharger;
      } else if (alertCase == 'pickCharger') {
        return pickCharger;
      } else {
        return universalAlert;
      }
    },
  );
}

class CustomInputFormatterSpace extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(
            ' '); // Replace this with anything you want to put after each 4 numbers
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}

class CustomInputFormatterSlash extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        buffer.write(
            '/'); // Replace this with anything you want to put after each 4 numbers
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}

class SharedPrefs {
  static SharedPreferences _sharedPrefs =
      SharedPreferences.getInstance() as SharedPreferences;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }
// username/email

  String get username => _sharedPrefs.getString("keyUsername") ?? "";

  set username(String value) {
    _sharedPrefs.setString("keyUsername", value);
  }

  deleteUsername() async {
    _sharedPrefs.remove("keyUsername");
  }

// paymentCard

  String get paymentCard => _sharedPrefs.getString("keyPayment") ?? "";

  set paymentCard(String value) {
    _sharedPrefs.setString("keyPayment", value);
  }

  deletePaymentCard() async {
    _sharedPrefs.remove("keyPayment");
  }

  // charging

  String get charging => _sharedPrefs.getString("keyCharging") ?? "";

  set charging(String value) {
    _sharedPrefs.setString("keyCharging", value);
  }

  deleteCharging() async {
    _sharedPrefs.remove("keyCharging");
  }

  // station code, savādāk, kad atgriežas tas domā, ir taimera režīms,
  // bet staion: 000 un ar pogu nekur nevar tikt

  String get chargingStation =>
      _sharedPrefs.getString("keyChargingStation") ?? "";

  set chargingStation(String value) {
    _sharedPrefs.setString("keyChargingStation", value);
  }

  deleteChargingStation() async {
    _sharedPrefs.remove("keyChargingStation");
  }
}
