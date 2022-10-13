import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// https://api.biorganikpazar.com/tezgah/giris
class ApiService {
/*
    static Future<String> login({
    required String user,
    required String pass,
  }) async {
    var params = {"kullanici": user, "sifre": pass};

    final http.Response response = await http.post(
      Uri.parse(Uri.encodeFull("https://api.biorganikpazar.com/tezgah/giris")),
      headers: {},
      body: json.encode(params),
    );
    if (response.statusCode == 200) {
      debugPrint("API Body --> " + response.body);
      return response.body;
    } else {
      throw Exception(
        "İstek durumu başarısız oldu. Hata kodu: ${response.statusCode}",
      );
    }  
  }*/

  static Future<String> Altin({
    String user = "",
    String pass = "",
  }) async {
    var params = {"kullanici": user, "sifre": pass};

    final http.Response response = await http.get(
      Uri.parse(Uri.encodeFull(
          "https://www.kirazaltin.com.tr/uygulama/icerikler/kurlar")),
      headers: {
        "App-Key": "Hiosis",
        "App-Secret": "b714337aa8007c433329ef43c7b8252c",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      return (utf8.decode(response.bodyBytes));
    } else {
      throw Exception(
        "İstek durumu başarısız oldu. Hata kodu: ${response.statusCode}",
      );
    }
  }

  static Future<String> GenelBilgiler() async {
    final http.Response response = await http.get(
      Uri.parse(Uri.encodeFull(
          "https://www.kirazaltin.com.tr/uygulama/icerikler/genel")),
      headers: {
        "App-Key": "Hiosis",
        "App-Secret": "b714337aa8007c433329ef43c7b8252c",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      return (utf8.decode(response.bodyBytes));
    } else {
      throw Exception(
        "İstek durumu başarısız oldu. Hata kodu: ${response.statusCode}",
      );
    }
  }

  static Future<String> UrunByCat({
    String catid = "",
  }) async {
    //var params = {"catid": catid};

    final http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(
          "https://www.kirazaltin.com.tr/uygulama/icerikler/urunler/" + catid)),
      headers: {
        "App-Key": "Hiosis",
        "App-Secret": "b714337aa8007c433329ef43c7b8252c",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      return (utf8.decode(response.bodyBytes));
    } else {
      throw Exception(
        "İstek durumu başarısız oldu. Hata kodu: ${response.statusCode}",
      );
    }
  }

  static Future<String> Kategori({
    String user = "",
    String pass = "",
  }) async {
    var params = {"kullanici": user, "sifre": pass};

    final http.Response response = await http.get(
      Uri.parse(Uri.encodeFull(
          "https://www.kirazaltin.com.tr/uygulama/icerikler/kategoriler")),
      headers: {
        "App-Key": "Hiosis",
        "App-Secret": "b714337aa8007c433329ef43c7b8252c",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      debugPrint("cats->" + response.body);
      return (utf8.decode(response.bodyBytes));
    } else {
      throw Exception(
        "İstek durumu başarısız oldu. Hata kodu: ${response.statusCode}",
      );
    }
  }

  static Future<String> Kampanya({
    String user = "",
    String pass = "",
  }) async {
    final http.Response response = await http.get(
      Uri.parse(Uri.encodeFull(
          "https://www.kirazaltin.com.tr/uygulama/icerikler/kampanyalar")),
      headers: {
        "App-Key": "Hiosis",
        "App-Secret": "b714337aa8007c433329ef43c7b8252c",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      return (utf8.decode(response.bodyBytes));
    } else {
      throw Exception(
        "İstek durumu başarısız oldu. Hata kodu: ${response.statusCode}",
      );
    }
  }

  static Future<String> getOrderData({required String tezgahKodu}) async {
    final http.Response response = await http.post(
      Uri.parse(
          Uri.encodeFull("https://api.biorganikpazar.com/tezgah/tezgahmain")),
      headers: {},
      body: json.encode({"tezgah_kodu": tezgahKodu}),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
        "İstek durumu başarısız oldu. Hata kodu: ${response.statusCode}",
      );
    }
  }

  static Future<String> getOrderDetails({
    required String tezgahKodu,
    required String siparisKodu,
  }) async {
    var params = {"tezgah_kodu": tezgahKodu, "siparis_kodu": siparisKodu};
    final http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(
          "https://api.biorganikpazar.com/tezgah/siparisincele")),
      headers: {},
      body: json.encode(params),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
        "İstek durumu başarısız oldu. Hata kodu: ${response.statusCode}",
      );
    }
  }
}
