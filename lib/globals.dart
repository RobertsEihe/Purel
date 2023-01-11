import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'servicesSQL.dart';
import 'profilePage.dart';

//////  GLOBĀLI MAINĪGIE  //////

int currentIndex = 0;

//////  GLOBĀLAS FUNKCIJAS  //////

// SHARED PREFI

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

// password
  String get password => _sharedPrefs.getString("keyPassword") ?? "";
  set password(String value) {
    _sharedPrefs.setString("keyPassword", value);
  }

  deletePassword() async {
    _sharedPrefs.remove("keyPassword");
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

// charging station number

  String get chargingStation =>
      _sharedPrefs.getString("keyChargingStation") ?? "";
  set chargingStation(String value) {
    _sharedPrefs.setString("keyChargingStation", value);
  }

  deleteChargingStation() async {
    _sharedPrefs.remove("keyChargingStation");
  }
}

// ALERT DIALOG

showAlertDialog(BuildContext context, String alertCase, String chargeTime,
    String chargePrice, String stationInfo, String stationNumber) {
  // Create button

  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  Widget chrgButton = TextButton(
    child: Text(stationInfo),
    onPressed: () {
      currentIndex = 1;
      Navigator.of(context).pop();
    },
  );
  Widget closeButton = TextButton(
    child: const Text("Close"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog universalAlert = AlertDialog(
    title: const Text("Uzmanību!"),
    content: const Text("Kaut kas nogāja greizi, mēģini vēlreiz!"),
    actions: [
      okButton,
    ],
  );

  AlertDialog addCardMail = AlertDialog(
    title: const Text("Uzmanību!"),
    content: const Text(
        "Lai varētu sākt uzlādi, pievienojiet e-pastu un maksājumu kartes datus."),
    actions: [
      okButton,
    ],
  );

  AlertDialog busyCharger = AlertDialog(
    title: const Text("Stacija aizņemta"),
    content: const Text(
        "Šī stacija ir aizņemta. Pārbaudiet vai stacijas numurs ievadīts pareizi. Vai izvēlieties citu staciju."),
    actions: [
      okButton,
    ],
  );
  AlertDialog enterCharger = AlertDialog(
    title: const Text("Ievadiet Stacijas Numuru"),
    content: const Text(
        "Ievadiet trīs ciparu stacijas numuru, lai sāktu uzlādi. Stacijas numuru meklējiet blakus uzlādes kabelim vai lietotnē kartē."),
    actions: [
      okButton,
    ],
  );

  var tariffVar;

  AlertDialog finishedCharging = AlertDialog(
    title: const Text('Uzlāde pabeigta'),
    content: displaySpentTimeAndMoney(chargeTime, chargePrice),
    //Text('suns'),
    actions: [
      okButton,
    ],
  );

  AlertDialog pickCharger = AlertDialog(
    title: Text("Stacija nr. " + stationNumber),
    //content: Text("Pick a charger! okay, I will pick"),
    content: SizedBox(
      width: 200,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [const Divider(), chrgButton, const Divider(), closeButton],
      ),
    ),
    // actions: [
    //   chrgButton,
    // ],
  );

  AlertDialog enetrEmail = AlertDialog(
    title: const Text("Uzmanību!"),
    content: const Text(
        "Lūdzu ievadiet e-pastu šādā formā: aaa@aaa.aaa, lai varētu izveidot profilu."),
    actions: [
      okButton,
    ],
  );

  AlertDialog emailUsed = AlertDialog(
    title: const Text("Uzmanību!"),
    content:
        const Text("Šāds e-pasts jau ir pievienots, izmantojiet citu e-pastu."),
    actions: [
      okButton,
    ],
  );

  AlertDialog deleteProfileFailed = AlertDialog(
    title: const Text("Uzmanību!"),
    content: const Text(
        "Vispirms jāpārtrauc uzlāde, lai varētu izdzēst profilu vai maksājumu kartes datus."),
    actions: [
      okButton,
    ],
  );

  AlertDialog incorrectCardNum = AlertDialog(
    title: const Text("Uzmanību!"),
    content: const Text("Ievadiet 16 ciparu kartes numuru."),
    actions: [
      okButton,
    ],
  );

  AlertDialog emptyCardHolder = AlertDialog(
    title: const Text("Uzmanību!"),
    content: const Text("Ievadiet kartes turētāja vārdu / nosaukumu."),
    actions: [
      okButton,
    ],
  );

  AlertDialog emptyCardMMYY = AlertDialog(
    title: const Text("Uzmanību!"),
    content: const Text("Ievadiet kartes derīguma termiņu."),
    actions: [
      okButton,
    ],
  );

  AlertDialog emptyCardCVC = AlertDialog(
    title: const Text("Uzmanību!"),
    content: const Text("Ievadiet kartes CVC."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      if (alertCase == 'addCardMail') {
        return addCardMail;
      } else if (alertCase == 'busyCharger') {
        return busyCharger;
      } else if (alertCase == 'enterCharger') {
        return enterCharger;
      } else if (alertCase == 'pickCharger') {
        return pickCharger;
      } else if (alertCase == 'finishedCharging') {
        return finishedCharging;
      } else if (alertCase == 'enterEmail') {
        return enetrEmail;
      } else if (alertCase == 'emailUsed') {
        return emailUsed;
      } else if (alertCase == 'deleteProfileFailed') {
        return deleteProfileFailed;
      } else if (alertCase == 'incorrectCardNum') {
        return incorrectCardNum;
      } else if (alertCase == 'emptyCardHolder') {
        return emptyCardHolder;
      } else if (alertCase == 'emptyCardMMYY') {
        return emptyCardMMYY;
      } else if (alertCase == 'emptyCardCVC') {
        return emptyCardCVC;
      } else {
        return universalAlert;
      }
    },
  );
}

Text displaySpentTimeAndMoney(String chargeTimeString, String chargePrice) {
  int chargeTimeInt = int.parse(chargeTimeString);

  late num wholeHours;
  late num wholeMinutes;

  if (chargeTimeInt >= 60) {
    wholeHours = (chargeTimeInt / 60).floor();
    wholeMinutes = chargeTimeInt - (60 * wholeHours);
    return Text(
        'Iztērētais laiks: $wholeHours h $wholeMinutes min\nTarifs: 0.15 eiro minūtē\nKopā cena: $chargePrice eiro');
  } else {
    return Text(
        'Iztērētais laiks: $chargeTimeInt min\nTarifs: 0.15 eiro minūtē\nKopējā cena: $chargePrice eiro');
  }
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
        buffer.write(' ');
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
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}
