import 'dart:convert';
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
  Future<AppSettings> addSettingToPref(AppSettings appSettings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('appSettings', jsonEncode(appSettings.toJson()));
    return appSettings;
  }

  Future<AppSettings> getInitialAppSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String appsettings =  prefs.getString('appSettings') ?? null;
    if (appsettings == null) {
      return addSettingToPref(AppSettings(
          darkTheme: true,
          enableLarivaar: false,
          enableEnglish: true,
          enablePunjabi: true));
    }
    var jsonData = jsonDecode(appsettings.toString());
    return AppSettings.fromJson(jsonData);
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
}
