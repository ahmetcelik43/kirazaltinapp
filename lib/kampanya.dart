import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'services/api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/internet_check.dart';

class _HomePageUIState extends State<KampanyaPage> {
  var lastPressed;
  var isLoading = false;
  var data;
  var isError = false;
  var genelBilgiler;

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

  loadData() async {
    internet_check().then((value) async {
      if (value) {
        await ApiService.Kampanya().then(
          (value) {
            try {
              setState(() {
                data = jsonDecode((value))["result"];
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

  Future<void> _launchUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                  child: Center(
                    child: Text("Kampanyalar",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext ctxt, int i) {
                          return Card(
                            elevation: 2,
                            child: ListTile(
                                leading: FaIcon(FontAwesomeIcons.bell),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  //  Sağdan-Sola Hizalama
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      data[i]["aciklama"],
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "Başlangıç: " + data[i]["basla"],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    Text(
                                      "Bitiş: " + data[i]["bitis"],
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 13),
                                    )
                                  ],
                                ),
                                title: Text(data[i]["baslik"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                onTap: () {
                                  _launchUrl("https://www.kirazaltin.com.tr");
                                }),
                          );
                        }))
              ]),
            ));
  }
}

class KampanyaPage extends StatefulWidget {
  const KampanyaPage({Key? key}) : super(key: key);

  @override
  State<KampanyaPage> createState() => _HomePageUIState();
}
