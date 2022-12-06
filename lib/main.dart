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

import 'DataTableMySqlDemo/DataTableDemo.dart';
import 'DataTableMySqlDemo/Services.dart';
import 'DataTableMySqlDemo/Employee.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

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

  var station_code_n_1 = '0';
  var station_code_n_2 = '0';
  var station_code_n_3 = '0';

  var db = new Mysql();

  //BitmapDescriptor customMarker = BitmapDescriptor(); // attribūts

/*
  getCustomMarker() async {
    customMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'images/IconChrg4.png');
  }
*/

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
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
  late Future<MyUse> futureMyUse = fetchMyUse('100');
  @override
  void initState() {
    super.initState();
    //getCustomMarker();

    futureMyUse = fetchMyUse('100');

    _setMarker(LatLng(37.42796133580664, -122.085749655962));
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
                        markers: _markers,
                        polygons: _polygons,
                        polylines: _polylines,
                        initialCameraPosition: _kGooglePlex,
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
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                      onSaved: (pin1) {
                                        //station_code_n_1 = pin1;
                                        //print(station_code_n_1);
                                      },
                                      decoration:
                                          const InputDecoration(hintText: "0"),
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly,
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
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                      onSaved: (pin1) {},
                                      decoration:
                                          const InputDecoration(hintText: "0"),
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly,
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
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                      onSaved: (pin1) {},
                                      decoration:
                                          const InputDecoration(hintText: "0"),
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly,
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
                                  Text(
                                    '00:00:00',
                                    style: TextStyle(fontSize: 50),
                                  ),
                                ],
                              ),
                        ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () {
                            trisViena = station_code_n_1 +
                                station_code_n_2 +
                                station_code_n_3;
                            if (buttonIndex == 0) {
                              buttonIndex = 1;
                              Services.getUseSimple(trisViena).then((value) {
                                if (value == '[{"in_use":"N"}]') {
                                  print('varam lādēt');
                                  Services.updateUse(trisViena, 'Y');
                                } else {
                                  print('nevaram lādēt');
                                }
                              });
                            } else {
                              buttonIndex = 0;
                              Services.getUseSimple(trisViena).then((value) {
                                if (value == '[{"in_use":"Y"}]') {
                                  print('varam beigt lādēt');
                                  Services.updateUse(trisViena, 'N');
                                } else {
                                  print('nevaram bigt lādēt');
                                }
                              });
                            }
                            setState(() {
                              if (buttonIndex == 0) {
                                buttonName = 'Start Charging';
                              }
                              if (buttonIndex == 1) {
                                buttonName = 'Stop Charging';
                              }
                            });

                            /*
                            print('nostradaja spiediens');
                            db.getConnection().then(
                              (conn) {
                                String sql =
                                    'select location from kval_proj_1.chrg_stations where id_no = 213;';
                                conn.query(sql).then((results) {
                                  for (var row in results) {
                                    setState(() {
                                      print('nostradaja otrs');
                                      print(row[0]);
                                    });
                                  }
                                });
                              },
                            );
                            */
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
                  ),
      ),
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

  // šeit gesture:
  GestureDetector buildAccountOption(
      BuildContext context, String title, int pageNext) {
    return GestureDetector(
      onTap: () {
        pageNext == 1
            ? Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const SecondPageOne();
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

class SecondPageOne extends StatelessWidget {
  const SecondPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page One'),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              color: Colors.deepPurple[200],
              child: Icon(
                Icons.power_rounded,
                size: 80,
                color: Colors.purple,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              color: Colors.deepPurple[200],
              child: Icon(
                Icons.drive_eta,
                size: 80,
                color: Colors.purple,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              color: Colors.deepPurple[200],
              child: Icon(
                Icons.account_circle,
                size: 80,
                color: Colors.purple,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              color: Colors.deepPurple[200],
            ),
          ),
        ],
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
  var cardNumber1;
  var cardNumber2;
  var cardNumber3;
  var cardNumber4;
  late String cardHolder;
  var cardMM;
  var cardYY;
  String buttonName = 'Save card';
  int buttonIndex = 0;

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
                            width: 50,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 4) {
                                  cardNumber1 = value;
                                  print(cardNumber1);
                                  FocusScope.of(context).nextFocus();
                                }
                                if (value.length == 0) {
                                  cardNumber1 = value;
                                  print(cardNumber1);
                                }
                              },
                              onSaved: (pin1) {},
                              decoration:
                                  const InputDecoration(hintText: "Pay"),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 4) {
                                  cardNumber2 = value;
                                  print(cardNumber2);
                                  FocusScope.of(context).nextFocus();
                                }
                                if (value.length == 0) {
                                  cardNumber2 = value;
                                  print(cardNumber2);
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              onSaved: (pin1) {},
                              decoration:
                                  const InputDecoration(hintText: "card "),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 4) {
                                  cardNumber3 = value;
                                  print(cardNumber3);
                                  FocusScope.of(context).nextFocus();
                                }
                                if (value.length == 0) {
                                  cardNumber3 = value;
                                  print(cardNumber3);
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              onSaved: (pin1) {},
                              decoration:
                                  const InputDecoration(hintText: " num"),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 4) {
                                  cardNumber4 = value;
                                  print(cardNumber4);
                                  FocusScope.of(context).nextFocus();
                                }
                                if (value.length == 0) {
                                  cardNumber4 = value;
                                  print(cardNumber4);
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              onSaved: (pin1) {},
                              decoration:
                                  const InputDecoration(hintText: "ber"),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: TextFormField(
                          onChanged: (value) {
                            /*
                    if (value.length == 16) {
                      cardHolder = value;
                      print(cardHolder);
                      //FocusScope.of(context).nextFocus();
                      // varbut uzlikt, lai cardHolder = value ārpus
                      // if (value.length) lai, pēc katras izmaiāns ieraksta
                      // mainīgajā vērtību
                      // jānotestē terminālī printējot
                    }
                    */
                            cardHolder = value;
                            print(cardHolder);
                          },
                          onSaved: (pin1) {},
                          decoration: const InputDecoration(
                              hintText: "Payment card holder"),
                          style: Theme.of(context).textTheme.headline6,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
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
                            width: 95,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 2) {
                                  cardMM = value;
                                  print(cardMM);
                                  FocusScope.of(context).nextFocus();
                                }
                                if (value.length == 0) {
                                  cardYY = value;
                                  print(cardMM);
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              onSaved: (pin1) {},
                              decoration: const InputDecoration(hintText: "MM"),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          Text('/'),
                          SizedBox(
                            height: 50,
                            width: 95,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 2) {
                                  cardYY = value;
                                  print(cardYY);
                                  FocusScope.of(context).nextFocus();
                                }
                                if (value.length == 0) {
                                  cardYY = value;
                                  print(cardYY);
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              onSaved: (pin1) {},
                              decoration: const InputDecoration(hintText: "YY"),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2),
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
                                '**** 2473  Rober ...',
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
                } else {
                  buttonIndex = 0;
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
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 180,
              color: Colors.deepPurple[200],
              child: Icon(
                Icons.call,
                size: 80,
                color: Colors.purple,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 180,
              color: Colors.deepPurple[200],
              child: Icon(
                Icons.chat,
                size: 80,
                color: Colors.purple,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 180,
              color: Colors.deepPurple[200],
              child: Icon(
                Icons.mail_outline,
                size: 80,
                color: Colors.purple,
              ),
            ),
          ),
        ],
      ),
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

Future<MyUse> fetchMyUse(String id_no) async {
  var map = Map<String, dynamic>();
  map['action'] = "GET_USE";
  map['id_no'] = id_no;
  final response =
      await http.post(Uri.parse('http://192.168.101.8/roberts.php'), body: map);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return MyUse.fromJson(jsonDecode(response.body));
    return MyUse.fromJson(jsonDecode(response.body)[0]);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class MyUse {
  //String id_no;
  String in_use;
  //String location;

  MyUse(
      {/*required this.id_no,*/ required this.in_use /*required this.location*/});

  factory MyUse.fromJson(Map<String, dynamic> json) {
    return MyUse(
      //id_no: json['id_no'] as String,
      in_use: json['in_use'] as String,
      //location: json['location'] as String,
    );
  }
}
