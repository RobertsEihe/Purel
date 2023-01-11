import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'globals.dart';
import 'servicesSQL.dart';

class SecondPageOne extends StatefulWidget {
  SecondPageOne({super.key});

  @override
  State<SecondPageOne> createState() => _SecondPageOneState();
}

class _SecondPageOneState extends State<SecondPageOne> {
  int buttonIndex = 0;
  late String emailSaved = '';
  String emailSQL = '';
  bool updateEmail = false;

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
        backgroundColor: const Color.fromARGB(255, 166, 59, 185),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Profils'),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.topCenter,
          //color: Colors.amber,
          width: 300,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200,
                    //color: Colors.deepPurple[200],
                    child: const Icon(
                      Icons.account_circle,
                      size: 90,
                      color: Colors.purple,
                    ),
                  ),
                ),
                buttonIndex == 0
                    ? Column(children: [
                        const Text(
                          'Ievadiet e-pastu:',
                          style: TextStyle(fontSize: 20),
                        ),
                        const Padding(padding: EdgeInsets.all(8.0)),
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
                              isDense: true,
                              hintText: "  e-pasts",
                              border: OutlineInputBorder(),
                            ),
                            style: Theme.of(context).textTheme.headline6,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.left,

                            // inputFormatters: [
                            // LengthLimitingTextInputFormatter(19),
                            // new CustomInputFormatterSpace(),
                            // ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(8.0)),
                        saveEmailFunction(),
                      ])
                    : buttonIndex == 1
                        ? Column(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  deleteProfileFunction(),
                                  changeEmailFunction(),
                                ],
                              )
                            ],
                          )
                        : Column(children: [
                            SizedBox(
                              height: 50,
                              width: 250,
                              child: Text(
                                //name,
                                SharedPrefs().username,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(8.0)),
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
                                  hintText: "  jaunais e-pasts",
                                  border: OutlineInputBorder(),
                                ),
                                style: Theme.of(context).textTheme.headline6,
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.left,

                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(250),
                                ],
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(8.0)),
                            saveEmailFunction(),
                          ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///// FUNKCIJAS /////

  pageStartState(int buttonState) async {
    if (SharedPrefs().username.length > 1) {
      buttonIndex = 1;
      setState(() {});
    } else {
      buttonIndex = 0;
      setState(() {});
    }
  }

  saveEmailFunction() {
    return ElevatedButton(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 166, 59, 185))),
      onPressed: () async {
        final bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailSaved);

        await Services.getEmail(emailSaved).then((value) {
          emailSQL = value;
        });
        if (emailSQL == '[{"email":"$emailSaved"}]') {
          showAlertDialog(context, 'emailUsed', '0', '0', '0', '0');
        } else if (!emailValid) {
          showAlertDialog(context, 'enterEmail', '0', '0', '0', '0');
        } else if (emailSaved == '') {
          showAlertDialog(context, 'enterEmail', '0', '0', '0', '0');
        } else {
          // šajā vieta jāieliek e-pasta arī MySql users tabulā
          if (updateEmail) {
            Services.updateEmail(emailSaved, SharedPrefs().username);
            updateEmail = false;
          } else {
            Services.addEmail(emailSaved);
          }
          SharedPrefs().username = emailSaved;
        }

        if (SharedPrefs().username.isNotEmpty &&
            SharedPrefs().username == emailSaved) {
          buttonIndex = 1;
        }

        setState(() {});
      },
      child: const Text('Saglabāt e-pastu'),
    );
  }

  deleteProfileFunction() {
    return ElevatedButton(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 166, 59, 185))),
      onPressed: () async {
        if (buttonIndex == 1) {
          if (SharedPrefs().charging != 'Y') // šis vēl jāpārbauda
          {
            deleteProfileFunctionAlert();
          } else {
            showAlertDialog(context, 'deleteProfileFailed', '0', '0', '0', '0');
          }
        } else {
          buttonIndex = 1;
        }
        setState(() {});
      },
      child: const Text('Dzēst profilu'),
    );
  }

  deleteProfileFunctionAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Uzmanību!"),
          content: const Text(
              "Vai Jūs gribat izdzēst e-pasta un maksājumu kartes infromāciju?"),
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
                Services.deleteEmail(SharedPrefs().username);
                SharedPrefs().deletePaymentCard();
                SharedPrefs().deleteUsername();
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

  changeEmailFunction() {
    return OutlinedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 166, 59, 185),
        ),
      ),
      onPressed: () {
        buttonIndex = 2;
        updateEmail = true;
        setState(
            () {}); // šāds set state ir vajadzīgs, jo liek mainīt ekrānam stāvokli (uz buttonIndex == 2)
      },
      child: const Text('nomainīt e-pastu'),
    );
  }
}