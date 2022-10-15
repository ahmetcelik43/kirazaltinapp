import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'services/api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'services/internet_check.dart';

class _HomePageUIState extends State<DovizPage> {
  var lastPressed;
  var isError;
  var isLoading;
  var data;

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
        await ApiService.Altin().then(
          (value) {
            try {
              setState(() {
                data = jsonDecode((value))["result"]["DOVIZ"];
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

  _dateSet() {
    tz.initializeTimeZones();
    final istanbulTimeeZone = tz.getLocation('Europe/Istanbul');
    tz.setLocalLocation(istanbulTimeeZone);
    final DateTime now = DateTime.now();
    var localizedDt = tz.TZDateTime.now(istanbulTimeeZone);
    final DateFormat dateFormat = DateFormat("dd.MM.yyyy HH:mm");
    lastPressed = dateFormat.format(localizedDt);
    return lastPressed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, bottom: 15),
            child: Center(
              child: Text("Canlı Altın Fiyatları",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          ),
          Expanded(
            child: SizedBox(
                height: 200.0,
                child: ListView.builder(
                  itemCount: data.keys.length,
                  itemBuilder: (BuildContext context, int i) {
                    String key = data.keys.elementAt(i);
                    var widget;

                    if (data.keys.length - 1 == i) {
                      widget = ListTile(
                          title: Center(
                        child: Text(_dateSet().toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 12)),
                      ));
                    } else {
                      String baslik = data[key]["BASLIK"];
                      String durum = data[key]["DURUM"].toString();
                      String resim = data[key]["RESIM"].toString();

                      var durumIcon;
                      if (durum == "up") {
                        durumIcon = Icon(
                          Icons.arrow_circle_up_rounded,
                          color: Colors.green,
                        );
                      }
                      if (durum == "down") {
                        durumIcon = Icon(
                          Icons.arrow_circle_down_rounded,
                          color: Colors.red,
                        );
                      }
                      if (durum == "stabil") {
                        durumIcon = Icon(
                          Icons.pause_circle_outline,
                        );
                      }

                      widget = Container(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                              elevation: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: SvgPicture.network(resim,
                                        height: 20, width: 20),
                                  ),
                                  SizedBox(
                                      width: 100,
                                      child: Text(
                                        data[key]["BASLIK"]
                                            .toString()
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                        textAlign: TextAlign.start,
                                      )),
                                  Spacer(),
                                  Expanded(
                                    child: Text("${data[key]["ALIS"]}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                        textAlign: TextAlign.left),
                                  ),
                                  Expanded(
                                      child: Text("${data[key]["SATIS"]}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                          textAlign: TextAlign.left)),
                                  Padding(
                                      padding: EdgeInsets.all(5),
                                      child: durumIcon)
                                ],
                              ))
                        ],
                      ));
                    }
                    return widget;
                  },
                )),
          ),
        ],
      )),
    );
  }
}

class DovizPage extends StatefulWidget {
  @override
  State<DovizPage> createState() => _HomePageUIState();
}
/*

   widget = Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                  elevation: 2,
                                  child: ListTile(
                                    leading: new SizedBox(
                                      width: 20,
                                      child: SvgPicture.network(
                                        resim,
                                      ),
                                    ),
                                    title: Row(children: <Widget>[
                                      Expanded(
                                          child: SizedBox(
                                              width: 50,
                                              child: Text(
                                                data[key]["BASLIK"]
                                                    .toString()
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.start,
                                              ))),
                                      Spacer(),
                                      Expanded(
                                          child: Text("₺${data[key]["ALIS"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                              textAlign: TextAlign.start)),
                                      Expanded(
                                          child: Text("₺${data[key]["SATIS"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14))),
                                    ]),
                                    trailing: durumIcon,
                                  ))
                            ],
                          ));


*/
