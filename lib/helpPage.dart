import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'globals.dart';

class SecondPageHelp extends StatelessWidget {
  const SecondPageHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 166, 59, 185),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'purel. Atbalsts',
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(8.0)),
            const Text(
              '24 / 7',
              style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            const Text(
              'Tehniskā palīdzība',
              style: TextStyle(fontSize: 20, color: Colors.purple),
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
            Container(
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                margin: const EdgeInsets.only(
                  left: 20.0,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.call,
                        size: 50, color: Color.fromARGB(255, 166, 59, 185)),
                    phoneCallFunction(),
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
            Container(
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                margin: const EdgeInsets.only(
                  left: 20.0,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.mail_outlined,
                        size: 50, color: Color.fromARGB(255, 166, 59, 185)),
                    emailSendingFunction(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///// FUNKCIJAS /////

  phoneCallFunction() {
    return TextButton(
      child: const Text(
        '+371 26828334',
        style: TextStyle(fontSize: 25),
      ),
      onPressed: () async {
        await launch("tel:+37126828334");
      },
    );
  }

  emailSendingFunction() {
    return TextButton(
      child: const Text(
        'roberts.eihe@gmail.com',
        style: TextStyle(fontSize: 23),
      ),
      onPressed: () async {
        String email = 'roberts.eihe@gmail.com';
        String subject = 'purel. Support';

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
            'subject': subject,
          }),
        );
        launchUrl(emailUri);
      },
    );
  }
}
