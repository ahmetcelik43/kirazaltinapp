import 'package:flutter/material.dart';
import 'services/api.dart';
/*import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_application_1/components/app_sizes.dart';
import 'package:flutter_application_1/components/app_colors.dart';
*/
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:core';
//import 'package:turkish/turkish.dart';
//import 'package:intl/intl.dart';
//import 'package:timezone/timezone.dart' as tz;
//import 'components/loading_indicator.dart';
//import 'package:timezone/data/latest.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UrunUI extends StatelessWidget with ChangeNotifier {
  UrunUI({required this.catid, required this.catname}) {}

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.post(
      Uri.parse(Uri.encodeFull(
          "https://www.kirazaltin.com.tr/uygulama/icerikler/urunler/" + catid)),
      headers: {
        "App-Key": "Hiosis",
        "App-Secret": "b714337aa8007c433329ef43c7b8252c",
        "Content-Type": "application/json",
      },
    );
    return jsonDecode(utf8.decode(result.bodyBytes))["result"];
  }

  Future<dynamic> genel() {
    return ApiService.GenelBilgiler();
  }

  String catid;
  String catname;

  // var detroit = tz.getLocation('Europe/Istanbul');
  //final localizedDt = tz.TZDateTime.from(DateTime.now(), detroit);
//  var lastPressed;
  bool _isLoading = true;
  bool _isError = false;
  var _userData;
  var _cats;
  // var localizedDt;

  Future<void> _launchInBrowser(String url) async {
    var scheme = url.split("://")[0];
    var host = scheme[1].split("/")[0];
    var path = url.replaceAll("https://www.kirazaltin.com.tr/", "");
    final Uri toLaunch =
        Uri(scheme: "https", host: "www.kirazaltin.com.tr", path: path);
    if (!await launchUrl(
      toLaunch,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri _url = Uri.parse(Uri.encodeFull(url));
    if (!await launchUrl(_url)) {
      throw 'Could not launch $url';
    }
  }

  bool _loading = true;

/*

*/

  @override
  Widget _buildUrun(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<dynamic>>(
        future: fetchUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: GridView.builder(
                        physics: ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.2,
                            crossAxisCount:
                                (MediaQuery.of(context).size.width ~/ 250)
                                    .toInt()),
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext ctxt, int i) {
                          return Container(
                              child: Card(
                            elevation: 2,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                //  Sağdan-Sola Hizalama
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    child: Image.network(
                                      snapshot.data[i]["urun_resim"],
                                    ),
                                  ),
                                  Center(
                                    child: new InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            snapshot.data[i]["baslik"],
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        onTap: () => _launchUrl(
                                            snapshot.data[i]["urun_link"])),
                                  ),
                                  Center(
                                    child: Text(
                                      snapshot.data[i]["urun_fiyat"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ]),
                          ));
                        })));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  var genelBilgiler;
  openwhatsapp(String phone, BuildContext context) async {
    var whatsappURl_android = "whatsapp://send?phone=" + phone + "&text=hello";
    var whatappURL_ios = "https://wa.me/$phone?text=${Uri.parse("hello")}";
    if (TargetPlatform.iOS == defaultTargetPlatform) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await _launchUrl(whatappURL_ios);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await _launchUrl(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("whatsapp no installed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Center(
              child: Image(
                image: AssetImage('assets/launcher/logo.png'),
                width: 200,
                height: 30,
              ),
            ),
            //https://stackoverflow.com/questions/49015038/removing-the-drop-shadow-from-a-scaffold-appbar-in-flutter
            elevation: 2.0,
            actions: [
              IconButton(
                onPressed: () {
                  genel().then(
                    (value) {
                      debugPrint(value);
                      openwhatsapp(
                          jsonDecode(value)["result"]["whatsapp"], context);
                    },
                  );
                },
                icon: Icon(
                  Icons.whatsapp_outlined,
                ),
              ),
            ]),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: Center(
                child: Text(catname,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
            Expanded(child: SingleChildScrollView(child: _buildUrun(context)))
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ));
  }
}
