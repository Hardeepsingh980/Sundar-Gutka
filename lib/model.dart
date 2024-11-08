
class Bani {
  final int id;
  final String name;
  final String baniData;

  Bani({required this.name, required this.baniData, required this.id});

  factory Bani.fromJson(json) {
    return Bani(
      id: json['id'],
      name: json['unicode'],
      baniData: '',
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
  final List<int> type;

  BaniContent(
      {required this.id,
      required this.name,
      required this.baniGurmukhi,
      required this.baniEnglish,
      required this.baniLarivar,
      required this.baniPunjabi,
      required this.type});

  factory BaniContent.fromJson(json) {
    List<String> gu = [];
    List<String> en = [];
    List<String> la = [];
    List<String> pu = [];
    List<int> type = [];

    print(json);

    for (var line in json['lines']) {
      gu.add(line['line']['gurmukhi']['unicode']);
      la.add(line['line']['larivaar']['unicode']);
      en.add(line['line']['translation']['english']['default']);
      pu.add(line['line']['translation']['punjabi']['default']['unicode']);
      type.add(line['line']['type']);
    }

    return BaniContent(
      id: json['baniinfo']['id'],
      name: json['baniinfo']['unicode'],
      baniGurmukhi: gu,
      baniEnglish: en,
      baniLarivar: la,
      baniPunjabi: pu,
      type: type,
    );
  }
}

class Hukam {
  final String date;
  final String ang;
  final List<String> baniGurmukhi;
  final List<String> baniEnglish;
  final List<String> baniPunjabi;

  Hukam({required this.date, required this.ang, required this.baniGurmukhi, required this.baniEnglish, required this.baniPunjabi});

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
  bool getGurupurab;
  bool getTest;
  String fontScale;

  AppSettings(
      {required this.darkTheme,
      required this.enableLarivaar,
      required this.enableEnglish,
      required this.enablePunjabi,
      required this.getHukam,
      required this.getGurupurab,
      required this.getTest,
      required this.fontScale});

  factory AppSettings.fromJson(json) {
    return AppSettings(
      darkTheme: json['dt'],
      enableLarivaar: json['la'],
      enableEnglish: json['en'],
      enablePunjabi: json['pu'],
      fontScale: json['fc'],
      getHukam: json['gh'],
      getGurupurab: json['gg'],
      getTest: json['gt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': this.darkTheme,
      'la': this.enableLarivaar,
      'en': this.enableEnglish,
      'pu': this.enablePunjabi,
      'fc': this.fontScale,
      'gh': this.getHukam,
      'gg': this.getGurupurab,
      'gt': this.getTest,
    };
  }

}
