import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'services/api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'services/internet_check.dart';

class _HomePageUIState extends State<IletisimPage> {
  // ignore: prefer_typing_uninitialized_variables
  var genelBilgiler;
  var isError;
  var isLoading;

  Future<void> _launchUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  openwhatsapp(String phone, BuildContext context) async {
    var whatsappURl_android = "whatsapp://send?phone=" + phone;
    var whatappURL_ios = "https://wa.me/$phone?text=${Uri.parse("hello")}";
    if (TargetPlatform.iOS == defaultTargetPlatform) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await _launchUrl(whatappURL_ios);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await _launchUrl(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

  loadData() async {
    internet_check().then((value) async {
      if (value) {
        await ApiService.GenelBilgiler().then(
          (value) {
            try {
              setState(() {
                genelBilgiler = jsonDecode((value));
              });
            } on Exception catch (exception) {
              isError = true;
            } catch (error) {
              isError = true;
            } finally {
              isLoading = false;
            }
          },
        );
      } else {
        _showDialog(
          title: "Hata",
          description: "Internet bağlantınızı kontrol edip tekrar deneyin.",
        );
      }
    });
  }

  @override
  void initState() {
    loadData();

    super.initState();
  }

  _showDialog({
    required String title,
    required String description,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Tekrar Dene",
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: Card(
                      child: Column(
                    children: [
                      Center(
                          child: Text(genelBilgiler["result"]["firma_adi"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30))),
                      SizedBox(height: 15),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.addressBook),
                        title: Text(genelBilgiler["result"]["adres"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        onTap: () {
                          var harita = genelBilgiler["result"]["harita"];
                          _launchUrl(harita);
                        },
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.globe),
                        title: Text("Web Sitesine Git",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        onTap: () {
                          var site = genelBilgiler["result"]["websitesi"];
                          _launchUrl(site);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text("E-Posta Gönder",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        onTap: () {
                          var site = genelBilgiler["result"]["eposta"];
                          _launchUrl("mailto:" + site);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.facebook),
                        title: Text("Facebook'a Git",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        onTap: () {
                          var site = genelBilgiler["result"]["facebook"];
                          _launchUrl(site);
                        },
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.youtube),
                        title: Text("Youtube'a Git",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        onTap: () {
                          var site = genelBilgiler["result"]["youtube"];
                          _launchUrl(site);
                        },
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.instagram),
                        title: Text("İnstagram'a Git",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        onTap: () {
                          var site = genelBilgiler["result"]["instagram"];
                          _launchUrl(site);
                        },
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.twitter),
                        title: Text("Twitter'a Git",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        onTap: () {
                          var site = genelBilgiler["result"]["twitter"];
                          _launchUrl(site);
                        },
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.whatsapp),
                        title: Text("Whatsapp'a Git",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        onTap: () {
                          var whatsapp = genelBilgiler["result"]["whatsapp"];
                          openwhatsapp(whatsapp, context);
                        },
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.phone),
                        title: Text("Ara",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        onTap: () {
                          var telefon = genelBilgiler["result"]["telefon"];
                          var telefonUrl = "tel://" + telefon;
                          _launchUrl(telefonUrl);
                        },
                      ),
                    ],
                  ))),
            ));
  }
}

class IletisimPage extends StatefulWidget {
  const IletisimPage({Key? key}) : super(key: key);

  @override
  State<IletisimPage> createState() => _HomePageUIState();
}
