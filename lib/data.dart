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
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<List<Bani>> getInitialFavourites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String favourites = prefs.getString('favourites') ?? '[]';
    var jsonData = jsonDecode(favourites);
    List<Bani> a = jsonData.map<Bani>((json) {
      return Bani.fromJson(json);
    }).toList();
    return a;
  }

  Future<List<Bani>> addFavourites(List<Bani> baniList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List list = [];
    baniList.forEach((element) {
      list.add(element.toJson());
    });
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

    if (appSettings.getGurupurab) {
      _firebaseMessaging.subscribeToTopic('gurupurab');
    } else {
      _firebaseMessaging.unsubscribeFromTopic('gurupurab');
    }

    if (appSettings.getTest) {
      _firebaseMessaging.subscribeToTopic('test');
    } else {
      _firebaseMessaging.unsubscribeFromTopic('test');
    }

    return appSettings;
  }

  Future<AppSettings> getInitialAppSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String appsettings = prefs.getString('appSettings') ??
        '''
{
  "dt": true,
  "la": false,
  "en": false,
  "pu": false,
  "gh": true,
  "gg": true,
  "gt": false,
  "fc": "Normal"
}
''';
    var jsonData = jsonDecode(appsettings);
    AppSettings a = AppSettings.fromJson(jsonData);
    return a;
  }

  Future<List<Bani>> getBaniList() async {
    print('Loading Bani List');
    var jsonData = await loadJson('assets/data/bani.json');
    print('Bani List Loaded, ${jsonData.length} items');
    List<Bani> baniList =
        jsonData.map<Bani>((json) => Bani.fromJson(json)).toList();
    return baniList;
  }

  Future<BaniContent> getBaniContent(id) async {
    print('Loading Bani Content for $id');
    var jsonData = await loadJson('assets/data/${id}.json');
    print('Bani Content Loaded');
    BaniContent baniContent = BaniContent.fromJson(jsonData);
    return baniContent;
  }

  Future<Hukam> getHukam() async {
    print('Getting Hukamnama');
    var url = 'https://api.gurbaninow.com/v2/hukamnama/today';
    Response response = await get(Uri.parse(url));
    print("Hukamnama Loaded");
    Map<String, dynamic> json_data = jsonDecode(response.body);
    return Hukam.fromJson(json_data);
  }
}
