import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'globals.dart' as globals;
import 'globals.dart';
import 'profilePage.dart';
import 'paymentPage.dart';
import 'helpPage.dart';
import 'servicesSQL.dart';
import 'locationList.dart';

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
      debugShowCheckedModeBanner: false,
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late String buttonName;
  int buttonIndex = 0;
  int currentIndex = 0;
  Duration duration = const Duration();
  late Duration startFromDuration;
  Timer? timer;

  var station_code_n_1 = '0';
  var station_code_n_2 = '0';
  var station_code_n_3 = '0';
  var trisViena = '0';
  var calcPriceVar;
  var countTimeVar;

  @override
  void initState() {
    super.initState();

    addMarkers(RigaLocation1, '100');
    addMarkers(RigaLocation2, '101');
    addMarkers(RigaLocation3, '102');
    addMarkers(RigaLocation4, '103');
    addMarkers(RigaLocation5, '104');
    addMarkers(RigaLocation6, '105');
    addMarkers(RigaLocation7, '106');
    addMarkers(RigaLocation8, '107');
    addMarkers(RigaLocation9, '108');
    addMarkers(RigaLocation10, '109');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageChargeStartState(buttonIndex);
      //SharedPrefs().deleteCharging();
    });

    startTimer();
    resetFrom();
  }

  @override
  Widget build(BuildContext context) {
    // galvenā ekrāna skata būve notiek šajā Widgetā
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 166, 59, 185),
        title: const Text('purel.'),
      ),
      body: Center(
          child: globals.currentIndex ==
                  0 // izvēlē starp 3 apakšējās navigācijas joslas pogām
              ? Container(
                  // šajā konteinerī tiek google maps izskats būvēts
                  child: Column(
                    children: [
                      Expanded(
                        child: GoogleMap(
                          mapType: MapType.normal,
                          markers: markers,
                          initialCameraPosition: _rigaLocation,
                        ),
                      ),
                    ],
                  ),
                )
              : globals.currentIndex == 1
                  ? Container(
                      // šajā konteinerī tiek lādēšanas izskats būvēts
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buttonIndex ==
                                  0 // šis indeks regulē kuru lādēšanas ekrānu rādīt atkarībā no nospiestās pogas stāvokļa
                              ? Column(
                                  children: [
                                    const Text(
                                      'Ievadiet stacijas numuru:',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    const Padding(padding: EdgeInsets.all(8.0)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        stationCodeEntering(context,
                                            1), // stacijas numura ievadīšanas funkcija
                                        stationCodeEntering(context, 2),
                                        stationCodeEntering(context, 3),
                                      ],
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
                                        'Stacija: ${trisViena}',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    buildTime(),
                                  ],
                                ),
                          chargingStartStopButton(
                              context), // lādēšanas ekrāna poga
                        ],
                      ),
                    )
                  : ListView(
                      children: [
                        buildAccountOption(context, "Profils",
                            1), // iestatījumu ekrāna izvēles lapas
                        buildAccountOption(context, "Maksāšana", 2),
                        buildAccountOption(context, "Palīdzība 24/7", 3),
                      ],
                    )),
      bottomNavigationBar: BottomNavigationBar(
        // apakšējā izvēles josla
        fixedColor: const Color.fromARGB(255, 166, 59, 185),
        items: const [
          BottomNavigationBarItem(
            label: 'Karte',
            icon: Icon(Icons.map),
          ),
          BottomNavigationBarItem(
            label: 'Uzlāde',
            icon: Icon(Icons.power),
          ),
          BottomNavigationBarItem(
            label: 'Iestatījumi',
            icon: Icon(Icons.settings),
          ),
        ],
        currentIndex: globals.currentIndex,
        onTap: (int index) {
          setState(() {
            globals.currentIndex = index;
          });
        },
      ),
    );
  }

  ///// MAP SCREEN FUNCTIONS /////

  static final CameraPosition _rigaLocation = const CameraPosition(
    // sākuma kameras pozīcija
    target: LatLng(56.9677, 24.1056),
    zoom: 14.4746,
  );

  Set<Marker> markers = Set(); //markers for google map

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    // mazo uzlādes staciju ikonas iegūšana no pieveinotās bildes
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  popUpCharging(String infWinTitle) {
    // uz ikonas uzpiestā reakcija
    String dataSnippet = 'nekas';
    Services.getAllInfo(infWinTitle).then((value) {
      dataSnippet = value;
      showAlertDialog(
          context, 'pickCharger', '0', '0', dataSnippet, infWinTitle);
    });
  }

  addMarkers(LatLng positionVar, String infWinTitle) async {
    // funkcija staciju marķieru definēšanai
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/IconChrg4.png",
    );

    Uint8List markerIcon =
        await getBytesFromAsset('assets/images/IconChrg4.png', 120);

    String dataSnippet = 'nekas';
    Services.getAllInfo(infWinTitle).then((value) {
      dataSnippet = value;

      markers.add(Marker(
        markerId: MarkerId(positionVar.toString()),
        position: positionVar, //position of marker

        onTap: () {
          setState(() {
            popUpCharging(infWinTitle);
          });
        },

        icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
      ));
    });

    setState(() {});
  }

  ///// CHARGING SCREEN FUNCTIONS /////

  chargingStartStopButton(context) {
    // uzlādes ekrāna pogas funkcija
    return ElevatedButton(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 166, 59, 185))),
      onPressed: () {
        if (trisViena == '000' || trisViena == '0') {
          // pārbaude uz ievadīto staciju
          showAlertDialog(context, 'enterCharger', '0', '0', '0', '0');
        } else {
          if (buttonIndex == 0) {
            // ja ir ievadīta stacija, tad ja poga ir sākt lādēt stāvoklī
            Services.updateTimerStart(SharedPrefs().username);
            buttonIndex = 1;

            Services.getUseSimple(trisViena).then((value) {
              // pārbaude vai stacija ir brīva
              if (value == '[{"in_use":"Pieejams"}]') {
                //buttonIndex = 1;
                if (SharedPrefs().username.isEmpty ||
                    SharedPrefs().paymentCard.isEmpty) {
                  buttonIndex = 0;
                  buttonName = 'Sākt uzlādi';
                  showAlertDialog(context, 'addCardMail', '0', '0', '0', '0');
                } else {
                  resetFrom();
                  Services.updateUse(trisViena, 'Nepieejams');
                  SharedPrefs().charging = 'Y';
                  SharedPrefs().chargingStation = trisViena;
                  //buttonIndex = 1;
                }
              } else {
                showAlertDialog(context, 'busyCharger', '0', '0', '0',
                    '0'); // paziņojums, ja ir aizņemta

                buttonIndex = 0;
                buttonName = 'Sākt uzlādi';
                trisViena = '0';
                station_code_n_1 = '0';
                station_code_n_2 = '0';
                station_code_n_3 = '0';
              }
            });
          } else {
            // stāvoklis beigt uzlādi
            buttonIndex = 0;
            Services.getUseSimple(trisViena).then((value) {
              if (value == '[{"in_use":"Nepieejams"}]') {
                Services.updateUse(trisViena, 'Pieejams');
                SharedPrefs().deleteCharging();
                countTimeVar = countTime().toString();
                Services.calcPrice(countTime().toString(), trisViena)
                    .then((value) {
                  calcPriceVar = value;

                  showAlertDialog(
                      context,
                      'finishedCharging',
                      countTimeVar,
                      calcPriceVar.toString(),
                      '0',
                      '0'); // izsauc uzlādes pabeigšanas diologu, kas tālāk izsauc cenas aprēķināšanu
                });

                trisViena = '0';
                station_code_n_1 = '0';
                station_code_n_2 = '0';
                station_code_n_3 = '0';
                SharedPrefs().deleteChargingStation();
              } else {
                SharedPrefs().deleteCharging();
              }
            });
          }

          setState(() {
            if (buttonIndex == 0) {
              buttonName = 'Sākt uzlādi';
            }
            if (buttonIndex == 1) {
              buttonName = 'Beigt uzlādi';
            }
          });
        }
      },
      child: Text(buttonName),
    );
  }

  stationCodeEntering(context, int position) {
    // staciajs numura ievadīšanas funkcijas implementācija
    return SizedBox(
      height: 90,
      width: 90,
      child: TextFormField(
        onChanged: (value) {
          if (value.length == 1) {
            if (position == 1) {
              station_code_n_1 = value;
              trisViena = station_code_n_1 +
                  station_code_n_2 +
                  station_code_n_3; // saglabā numuru uz reiz pēc cipara nospiešanas
            } else if (position == 2) {
              station_code_n_2 = value;
              trisViena =
                  station_code_n_1 + station_code_n_2 + station_code_n_3;
            } else if (position == 3) {
              station_code_n_3 = value;
              trisViena =
                  station_code_n_1 + station_code_n_2 + station_code_n_3;
            }

            FocusScope.of(context)
                .nextFocus(); // pāriet uz nākamo ciparu, ja ir aizpildīts iepriekšējais
          }
          if (value.length == 0) {
            if (position == 1) {
              station_code_n_1 = value;
              trisViena =
                  station_code_n_1 + station_code_n_2 + station_code_n_3;
            } else if (position == 2) {
              station_code_n_2 = value;
              trisViena =
                  station_code_n_1 + station_code_n_2 + station_code_n_3;
            } else if (position == 3) {
              station_code_n_3 = value;
              trisViena =
                  station_code_n_1 + station_code_n_2 + station_code_n_3;
            }

            FocusScope.of(context)
                .previousFocus(); // pāriet uz iepriekšējo ciparu, ja ir izdzēsts cipars
          }
        },
        onSaved: (pin1) {},
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: Colors.purpleAccent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 2.0,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.headline6,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  int countTime() {
    // laika skaitīšanas funkciajs implementācija
    // Laika skaitīšana sākuma punktu paņemot no datubāzes LAIKS_START

    Services.getTimer(SharedPrefs().username).then((value) {
      // funkcija laika iegūšanai no datubāzes
      // pēc lieottājvārda atrod datubāze LAIKS_START vērtību
      int minNum;
      int hourNum;
      int secondNum;
      String minString;
      String hourString;
      String secondString;
      // Šeit sākas datetime datu tipa, kurš ir pārvērst par stringu pārvēršana par Duration datu tipu.

      if (value.length == 22) {
        minString = value.substring(14, 16);
        hourString = value.substring(11, 13);
        secondString = value.substring(17, 19);
      } else {
        minString = value.substring(15, 17);
        hourString = value.substring(11, 14);
        secondString = value.substring(18, 20);
      }

      minNum = int.parse(minString); // šeit no string iegūtos pārvērš par int
      hourNum = int.parse(hourString);
      secondNum = int.parse(secondString);
      // šeit varu likt
      duration = Duration(
          minutes: minNum,
          seconds: secondNum); // šeit iegūtos int ievada kā manuālu laiku
    });

    int timeString = duration.inMinutes + 1;
    return timeString; // šeit ir iegūts laiks Int datu tipā, ko var izmantot cenas aprēķināšanai
  }

  updateTimerStartSQL() async {
    await Services.updateTimerStart(
        SharedPrefs().username); // datubāzes laika augšupielādēšanas funkcija
  }

  void addTime() {
    // taimera skaitīšanas funkcija
    final addSeconds = 1;

    setState(() {
      final secondsSis = duration.inSeconds + addSeconds;
      duration = Duration(seconds: secondsSis);
    });
  }

  void resetFrom() async {
    // taimera uzlikšana uz laiku no datubāzes
    Services.getTimer(SharedPrefs().username).then((value) {
      int minNum;
      int hourNum;
      int secondNum;
      String minString;
      String hourString;
      String secondString;
      if (value.length == 22) {
        minString = value.substring(14, 16);
        hourString = value.substring(11, 13);
        secondString = value.substring(17, 19);
      } else {
        minString = value.substring(15, 17);
        hourString = value.substring(11, 14);
        secondString = value.substring(18, 20);
      }

      minNum = int.parse(minString);
      hourNum = int.parse(hourString);
      secondNum = int.parse(secondString);
      duration = Duration(minutes: minNum, seconds: secondNum);
      setState(() {
        duration;
      });
    });
  }

  void startTimer() {
    // taimera sākšanas funkcija
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  pageChargeStartState(int buttonState) async {
    // lādēšansa lapas sākuma stāvokļa noteikšana - notiek uzlāde vai var ievadīt 3 ciparus
    if (SharedPrefs().charging.isNotEmpty) {
      buttonIndex = 1;
      buttonName = 'Beigt uzlādi';
      trisViena = SharedPrefs().chargingStation;
      Services.getTimer(SharedPrefs().username).then((value) {
        int minNum;
        int hourNum;
        int secondNum;
        String minString;
        String hourString;
        String secondString;

        if (value.length == 22) {
          minString = value.substring(14, 16);
          hourString = value.substring(11, 13);
          secondString = value.substring(17, 19);
        } else {
          minString = value.substring(15, 17);
          hourString = value.substring(11, 14);
          secondString = value.substring(18, 20);
        }

        minNum = int.parse(minString);
        hourNum = int.parse(hourString);
        secondNum = int.parse(secondString);

        duration = Duration(minutes: minNum, seconds: secondNum);
      });
      setState(() {});
    } else {
      buttonIndex = 0;
      buttonName = 'Sākt uzlādi';
      setState(() {});
    }
  }

  Widget buildTime() {
    // taimera attēlosānas funkcijas implementācija
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: minutes, header: 'Minūtes'),
        const SizedBox(width: 8),
        buildTimeCard(time: seconds, header: 'Sekundes'),
      ],
    );
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.purple),
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: const TextStyle(
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

  ///// SETTINGS SCREEN FUNCTIONS /////

  GestureDetector buildAccountOption(
      // šis 3 izvēles taustiņus padara par skārienjutīgām pogām
      BuildContext context,
      String title,
      int pageNext) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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
                : Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const SecondPageHelp();
                      },
                    ),
                  );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.purple),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.purple,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
