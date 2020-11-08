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

class AppSettings {
  bool darkTheme;
  bool enableLarivaar;
  bool enableEnglish;
  bool enablePunjabi;
  String fontScale;

  AppSettings(
      {this.darkTheme,
      this.enableLarivaar,
      this.enableEnglish,
      this.enablePunjabi,
      this.fontScale});

  factory AppSettings.fromJson(json) {
    return AppSettings(
      darkTheme: json['dt'],
      enableLarivaar: json['la'],
      enableEnglish: json['en'],
      enablePunjabi: json['pu'],
      fontScale: json['fc']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': this.darkTheme,
      'la': this.enableLarivaar,
      'en': this.enableEnglish,
      'pu': this.enablePunjabi,
      'fc': this.fontScale
    };
  }

}
