import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'globals.dart';
import 'servicesSQL.dart';

class SecondPageTwo extends StatefulWidget {
  @override
  State<SecondPageTwo> createState() => _SecondPageTwoState();
}

class _SecondPageTwoState extends State<SecondPageTwo> {
  // const SecondPageTwo({super.key});
  var cardNumber = '';
  late String cardHolder;
  var cardMMYY = '';
  var cardCVC = '';
  //String buttonName = 'Save card';
  int buttonIndex = 0;
  late String mask;

  cardHolderShortName(String fullName) {
    String shortName;
    int endCount;
    int startCount;

    startCount = fullName.indexOf(' ');

    endCount = startCount + 4;

    if (endCount >= fullName.length) {
      shortName = fullName;
    } else {
      shortName = fullName.substring(0, endCount) + ' ...';
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
    // Galvenā funkcija, kas maksājumu metodes lapā būvē visu kopā/
    return Scaffold(
      // Galvenajā funkcijā var saskatīt visu maksājumu lapas struktūru,
      appBar: AppBar(
        // kas sastāv no mazākām funkcijām.
        backgroundColor: const Color.fromARGB(255, 166, 59, 185),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Maksāšanas informācija'),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          margin:
              const EdgeInsets.only(top: 60, bottom: 300, left: 60, right: 60),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.purple),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              buttonIndex == 0
                  ? Column(
                      children: [
                        cardNumberInputFunction(),
                        cardHolderInputFunction(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            cardMMYYinputFunction(),
                            const Padding(
                                padding: EdgeInsets.only(left: (19.0))),
                            cardCVCinputFunction(),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.all(8.0)),
                        saveCardFunction(),
                        const Padding(padding: EdgeInsets.all(8.0)),
                      ],
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '**** ' + SharedPrefs().paymentCard,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        deleteCardFunction(),
                      ],
                    ),
              const Padding(padding: EdgeInsets.all(8.0)),
            ],
          ),
        ),
      ),
    );
  }

  ///// FUNKCIJAS /////

  saveCardFunction() {
    return ElevatedButton(
      // Maksājumu kartes saglabāšanas funkcija, kurā notiek ievadīto datu validācija.
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 166, 59, 185))),
      onPressed: () {
        if (buttonIndex == 0) {
          if (cardNumber.isEmpty) {
            showAlertDialog(context, 'incorrectCardNum', '0', '0', '0',
                '0'); // funkcija paziņojuma dialoga parādīšanai
          } else if (cardHolder.isEmpty) {
            showAlertDialog(context, 'emptyCardHolder', '0', '0', '0', '0');
          } else if (cardMMYY.isEmpty) {
            showAlertDialog(context, 'emptyCardMMYY', '0', '0', '0', '0');
          } else if (cardCVC.isEmpty) {
            showAlertDialog(context, 'emptyCardCVC', '0', '0', '0', '0');
          } else if (cardNumber.length != 19) {
            showAlertDialog(context, 'incorrectCardNum', '0', '0', '0', '0');
          } else if (cardMMYY.length != 5) {
            showAlertDialog(context, 'emptyCardMMYY', '0', '0', '0', '0');
          } else if (cardCVC.length != 3) {
            showAlertDialog(context, 'emptyCardCVC', '0', '0', '0', '0');
          } else {
            SharedPrefs()
                    .paymentCard = // piekļuve lokālajai failu glabātuvei, kur ieraksta
                // ignore: prefer_interpolation_to_compose_strings
                cardNumber.substring(cardNumber.length -
                        5) + // fragmentu no bankas kartes datiem, lai parādītu uz ekrāna
                    '  ' + // tad, kad ir skats "karte ir saglabāta"
                    cardHolderShortName(cardHolder);
            buttonIndex = 1;
          }
        } else {
          buttonIndex = 0;
        }
        setState(() {});
      },
      child: const Text('Saglabāt karti'),
    );
  }

  deleteCardFunction() {
    return ElevatedButton(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 166, 59, 185))),
      onPressed: () async {
        if (SharedPrefs().charging != 'Y') {
          deleteCardFunctionAlert();
        } else {
          showAlertDialog(context, 'deleteProfileFailed', '0', '0', '0', '0');
        }

        setState(() {});
      },
      child: const Text('Dzēst karti'),
    );
  }

  deleteCardFunctionAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Warning!"),
          content: const Text("Vai Jūs gribat izdzēst maksājumu kartes datus?"),
          actions: [
            TextButton(
              child: const Text("Atcelt"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Dzēst"),
              onPressed: () {
                SharedPrefs().deletePaymentCard();
                buttonIndex = 0;
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  cardNumberInputFunction() {
    return SizedBox(
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
          hintText: "  Kartes numurs",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purpleAccent,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purple,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.headline6,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(19),
          FilteringTextInputFormatter.digitsOnly,
          new CustomInputFormatterSpace(),
        ],
      ),
    );
  }

  cardHolderInputFunction() {
    return SizedBox(
      height: 50,
      width: 240,
      child: TextFormField(
        onChanged: (value) {
          cardHolder = value;
          print(cardHolder);
        },
        //onSaved: (pin1) {},
        decoration: const InputDecoration(
          hintText: "  Vārds / Nosaukums",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purpleAccent,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purple,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.headline6,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(24),
        ],
      ),
    );
  }

  cardMMYYinputFunction() {
    return SizedBox(
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
        decoration: const InputDecoration(
          hintText: "MM/YY",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purpleAccent,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purple,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.headline6,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(5),
          FilteringTextInputFormatter.digitsOnly,
          new CustomInputFormatterSlash()
        ],
      ),
    );
  }

  cardCVCinputFunction() {
    return SizedBox(
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
        decoration: const InputDecoration(
          hintText: "CVC",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purpleAccent,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purple,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.headline6,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(3),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}
