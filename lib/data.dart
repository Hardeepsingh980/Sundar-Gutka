import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model.dart';

import 'package:flutter/services.dart' show rootBundle;

loadJson(String filepath) async {
  String data = await rootBundle.loadString(filepath);
  var jsonResult = json.decode(data);
  return jsonResult;
}

class ApiClass {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  Future<List<Bani>> getInitialFavourites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String favourites = prefs.getString('favourites') ?? null;
    if (favourites == null) {
      return [];
    }
    var jsonData = jsonDecode(favourites.toString());
    List<Bani> a = jsonData.map<Bani>((json) {
      return Bani.fromJson(json);
    }).toList();
    return a;
  }

  Future<List<Bani>> addFavourites(List<Bani> baniList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List list = [];
    baniList.forEach((element) { list.add(element.toJson()); });
    prefs.setString('favourites', jsonEncode(list));
    return baniList;
  }

  Future<AppSettings> addSettingToPref(AppSettings appSettings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('appSettings', jsonEncode(appSettings.toJson()));
    if (appSettings.getHukam) {
      _firebaseMessaging.subscribeToTopic('hukam');
    } else {
      _firebaseMessaging.unsubscribeFromTopic('hukam');
    }
    return appSettings;
  }

  Future<AppSettings> getInitialAppSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String appsettings =  prefs.getString('appSettings') ?? null;
    if (appsettings == null) {
      _firebaseMessaging.subscribeToTopic('hukam');
      return addSettingToPref(AppSettings(
          darkTheme: true,
          enableLarivaar: false,
          enableEnglish: true,
          enablePunjabi: true,
          fontScale: 'Normal',
          getHukam: true
          ));
    }
    var jsonData = jsonDecode(appsettings.toString());
    AppSettings a = AppSettings.fromJson(jsonData);
    if (a.getHukam == null) {
      _firebaseMessaging.subscribeToTopic('hukam');
      a.getHukam = true;
    }
    if (a.fontScale == null) {
      a.fontScale = 'Normal';
    }
    return a;
  }

  Future<List<Bani>> getBaniList() async {
    var jsonData = await loadJson('assets/data/bani.json');
    List<Bani> baniList =
        jsonData.map<Bani>((json) => Bani.fromJson(json)).toList();
    return baniList;
  }

  Future<BaniContent> getBaniContent(id) async {
    var jsonData = await loadJson('assets/data/${id}.json');
    BaniContent baniContent = BaniContent.fromJson(jsonData);
    return baniContent;
  }

  Future<Hukam> getHukam() async {
    var url = 'https://dev-api.gurbaninow.com/v2/hukamnama/today';
    Response response = await get(url);
    Map<String, dynamic> json_data = jsonDecode(response.body);
    return Hukam.fromJson(json_data);
  }

}
