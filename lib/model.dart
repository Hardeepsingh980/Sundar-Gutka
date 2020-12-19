import 'package:flutter/material.dart';

class Bani {
  final int id;
  final String name;
  final String baniData;

  Bani({this.name, this.baniData, this.id});

  factory Bani.fromJson(json) {
    return Bani(
      id: json['id'],
      name: json['unicode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'unicode': this.name,
    };
  }
  
}

class BaniContent {
  final int id;
  final String name;
  final List<String> baniGurmukhi;
  final List<String> baniEnglish;
  final List<String> baniLarivar;
  final List<String> baniPunjabi;

  BaniContent(
      {this.id,
      this.name,
      this.baniGurmukhi,
      this.baniEnglish,
      this.baniLarivar,
      this.baniPunjabi});

  factory BaniContent.fromJson(json) {
    List<String> gu = [];
    List<String> en = [];
    List<String> la = [];
    List<String> pu = [];

    for (var line in json['bani']) {
      gu.add(line['line']['gurmukhi']['unicode']);
      la.add(line['line']['larivaar']['unicode']);
      en.add(line['line']['translation']['english']['default']);
      pu.add(line['line']['translation']['punjabi']['default']['unicode']);
    }

    return BaniContent(
      id: json['baniinfo']['id'],
      name: json['baniinfo']['unicode'],
      baniGurmukhi: gu,
      baniEnglish: en,
      baniLarivar: la,
      baniPunjabi: pu,
    );
  }
}

class Hukam {
  final String date;
  final String ang;
  final List<String> baniGurmukhi;
  final List<String> baniEnglish;
  final List<String> baniPunjabi;

  Hukam({this.date, this.ang, this.baniGurmukhi, this.baniEnglish, this.baniPunjabi});

  factory Hukam.fromJson(json) {
    List<String> gu = [];
    List<String> en = [];
    List<String> pu = [];

    for (var line in json['hukamnama']) {
      gu.add(line['line']['gurmukhi']['unicode']);
      en.add(line['line']['translation']['english']['default']);
      pu.add(line['line']['translation']['punjabi']['default']['unicode']);
    }


    return Hukam(
      ang: (json['hukamnamainfo']['pageno']).toString(),
      date: "${json['date']['nanakshahi']['punjabi']['day']}, ${json['date']['nanakshahi']['punjabi']['date']} ${json['date']['nanakshahi']['punjabi']['month']} ${json['date']['nanakshahi']['punjabi']['year']}",
      baniGurmukhi: gu,
      baniEnglish: en,
      baniPunjabi: pu,
    );
  }

}

class AppSettings {
  bool darkTheme;
  bool enableLarivaar;
  bool enableEnglish;
  bool enablePunjabi;
  bool getHukam;
  String fontScale;

  AppSettings(
      {this.darkTheme,
      this.enableLarivaar,
      this.enableEnglish,
      this.enablePunjabi,
      this.getHukam,
      this.fontScale});

  factory AppSettings.fromJson(json) {
    return AppSettings(
      darkTheme: json['dt'],
      enableLarivaar: json['la'],
      enableEnglish: json['en'],
      enablePunjabi: json['pu'],
      fontScale: json['fc'],
      getHukam: json['gh']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': this.darkTheme,
      'la': this.enableLarivaar,
      'en': this.enableEnglish,
      'pu': this.enablePunjabi,
      'fc': this.fontScale,
      'gh': this.getHukam
    };
  }

}
