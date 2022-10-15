import 'package:flutter/material.dart';
import 'kampanya.dart';
import 'urun.dart';
import 'package:http/http.dart';
import 'altin.dart';
import 'doviz.dart';
import 'iletisim.dart';
import 'services/api.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'services/internet_check.dart';

//1
//Upon init run this
void main() => runApp(MyApp());

/*
  Since materialApp is used once, declare it on StatelessWidget then 
  point the home into a StatefulWidget
*/
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
      50: Color.fromRGBO(223, 195, 70, .1),
      100: Color.fromRGBO(223, 195, 70, .2),
      200: Color.fromRGBO(223, 195, 70, .3),
      300: Color.fromRGBO(223, 195, 70, .4),
      400: Color.fromRGBO(223, 195, 70, .5),
      500: Color.fromRGBO(223, 195, 70, .6),
      600: Color.fromRGBO(223, 195, 70, .7),
      700: Color.fromRGBO(223, 195, 70, .8),
      800: Color.fromRGBO(223, 195, 70, .9),
      900: Color.fromRGBO(223, 195, 70, 1),
    };
    return MaterialApp(
      title: 'Kiraz Altın',
      theme: ThemeData(
          fontFamily: "Poppins",
          primarySwatch: MaterialColor(int.parse("0xffdfc346"), color)),
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

//3
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  //set initial value
  int _selectedPage = 0;
  var _cats;
  var _isError;
  var _isLoading = true;
  //workaround hack
  var _selectedTitle = 'Altın Fiyatları';

  var catid;

  var catname;

  ValueGetter catget() {
    return catid;
  }

  static set catset(String value) {}

  dynamic _pageOptions(int index) {
    if (index == 0) {
      return AltinPage();
    }
    if (index == 1) {
      return DovizPage();
    }
    if (index == 2) {
      return KampanyaPage();
    }
    if (index == 3) {
      return IletisimPage();
    }
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

  var genelBilgiler;
  loadData() async {
    internet_check().then((value) async {
      if (value) {
        ApiService.Kategori().then(
          (value) {
            try {
              _cats = jsonDecode((value));
              //_userData = jsonDecode(value);
            } on Exception catch (exception) {
              _isError = true;
            } catch (error) {
              _isError = true;
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          },
        );

        await ApiService.GenelBilgiler().then(
          (value) {
            try {
              setState(() {
                genelBilgiler = jsonDecode((value));
              });
            } on Exception catch (exception) {
              _isError = true;
            } catch (error) {
              _isError = true;
            } finally {
              _isLoading = false;
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

  List<dynamic> _buildUserGroups(BuildContext context) {
    List<dynamic> userGroup = [];
    for (var i = 0; i < _cats["result"].length; i++) {
      var temp2 = _cats["result"][i]["icerikler"];
      List<Widget> icerikler = [];
      if (temp2.length != 0) {
        for (var a = 0; a < _cats["result"][i]["icerikler"].length; a++) {
          //3 alt kategoriler
          List<Widget> icerikler3 = [];

          if (_cats["result"][i]["icerikler"][a]["icerikler"] != null) {
            var temp = _cats["result"][i]["icerikler"][a]["icerikler"];
            for (var b = 0; b < temp.length; b++) {
              icerikler3.add(Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: ListTile(
                    title: new Text(temp[b]["kategori_baslik"],
                        style: TextStyle(fontSize: 13.00)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UrunUI(
                                catid: temp[b]["kategori_id"],
                                catname: temp[b]["kategori_baslik"])),
                      );
                    },
                  )));
            }
            icerikler
              ..add(ExpansionTile(
                  title: Text(
                      _cats["result"][i]["icerikler"][a]["kategori_baslik"],
                      style: TextStyle(fontSize: 13.00)),
                  children: icerikler3));
          } else {
            icerikler
              ..add(Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: ListTile(
                    title: new Text(
                        _cats["result"][i]["icerikler"][a]["kategori_baslik"],
                        style: TextStyle(fontSize: 13.00)),
                    onTap: () {
                      debugPrint(
                          _cats["result"][i]["icerikler"][a]["kategori_id"]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UrunUI(
                                catid: _cats["result"][i]["icerikler"][a]
                                    ["kategori_id"],
                                catname: _cats["result"][i]["icerikler"][a]
                                    ["kategori_baslik"])),
                      );
                    },
                  )));
          }

          //3 alt kategoriler
        }
        userGroup
          ..add(ExpansionTile(
              title: Text(_cats["result"][i]["kategori_baslik"],
                  style: TextStyle(fontSize: 13.00)),
              children: icerikler));
      } else {
        userGroup
          ..add(ListTile(
            title: new Text(_cats["result"][i]["kategori_baslik"],
                style: TextStyle(fontSize: 13.00)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UrunUI(
                        catid: _cats["result"][i]["icerikler"]["kategori_id"],
                        catname: _cats["result"][i]["icerikler"]
                            ["kategori_baslik"])),
              );

              Navigator.pop(context);
            },
          ));
      }
    }

    return userGroup;
  }

  Widget buildNavigationDrawer(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Color.fromRGBO(223, 195, 70, 1),
        ),
        child: Image(
          image: AssetImage('assets/launcher/logo.png'),
          width: 200,
          height: 50,
        ),
      ),
      ..._buildUserGroups(context)
    ]));
  }

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

  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            //header
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
                      var whatsapp = genelBilgiler["result"]["whatsapp"];
                      openwhatsapp(whatsapp, context);
                    },
                    icon: Icon(
                      Icons.whatsapp_outlined,
                    ),
                  ),
                ]),

            //body -> content of page selected
            //fired via sidemenu @ tabs (refer: onTap)
            body: _pageOptions(_selectedPage),

            drawer: buildNavigationDrawer(context),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              iconSize: 20,
              selectedIconTheme:
                  IconThemeData(color: Color(0xffdfc346), size: 25),
              selectedLabelStyle:
                  TextStyle(color: Color.fromARGB(255, 105, 105, 104)),
              //currentIndex -> tab index value
              currentIndex: _selectedPage,

              elevation: 2.0,
              //upon tap
              onTap: (int index) {
                setState(() {
                  _selectedPage = index;

                  if (index == 0) {
                    _selectedTitle = 'Altın Fiyatları';
                  }

                  if (index == 1) {
                    _selectedTitle = 'Döviz Fiyatları';
                  }

                  if (index == 2) {
                    _selectedTitle = 'Kampanyalar';
                  }
                  if (index == 3) {
                    _selectedTitle = 'İletişim';
                  }
                });
              },

              items: [
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.coins), label: "Altın"),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.moneyBill),
                  label: "Döviz",
                ),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.bell), label: "Kampanyalar"),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.addressBook),
                    label: "İletişim"),
              ],
            ),
          );
  }
}
