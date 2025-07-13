import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sundargutka/bloc/details_bloc.dart';

import 'bloc/theme_bloc.dart';
import 'model.dart';

class BaniContentPage extends StatefulWidget {
  @override
  _BaniContentPageState createState() => _BaniContentPageState();
}

class _BaniContentPageState extends State<BaniContentPage> {
  getFontScale(scale) {
    if (scale == 'Small') {
      return 0.8;
    } else if (scale == 'Normal') {
      return 1;
    } else if (scale == 'Medium') {
      return 1.3;
    } else if (scale == 'Large') {
      return 1.7;
    }
  }

  bool fabIsVisible = true;
  bool appBarIsVisible = true;
  String baniName = '';
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        fabIsVisible = _scrollController.position.userScrollDirection ==
            ScrollDirection.forward;
        appBarIsVisible = fabIsVisible;
      });
    });
  }

  int initialSpeed = 5;

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    ThemeBloc themeBloc;
    themeBloc = BlocProvider.of<ThemeBloc>(context);

    return Scaffold(
      floatingActionButton: AnimatedOpacity(
          duration: Duration(milliseconds: 100),
          opacity: fabIsVisible ? 1 : 0,
          child: FloatingActionButton.extended(
            backgroundColor: Colors.orange,
            onPressed: null,
            icon: IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {
                  double maxExtent = _scrollController.position.maxScrollExtent;
                  double distanceDifference =
                      maxExtent - _scrollController.offset;
                  double durationDouble = distanceDifference / initialSpeed;
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(seconds: durationDouble.toInt()),
                    curve: Curves.elasticOut,
                  );
                }),
            label: CupertinoSlider(
              value: initialSpeed.toDouble(),
              onChanged: (v) {
                setState(() {
                  initialSpeed = v.toInt();
                });
              },
              min: 1,
              max: 10,
              activeColor: Colors.black,
            ),
          )),
      drawer: Drawer(
        child: BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
          return SettingsList(
            sections: [
              SettingsSection(title: const Text('Gurbani Settings'), tiles: [
                SettingsTile.switchTile(
                  title: const Text('Enable Larivaar'),
                  leading: const Icon(Icons.ac_unit),
                  initialValue: state.appSettings.enableLarivaar,
                  onToggle: (bool value) {
                    AppSettings a = state.appSettings;
                    a.enableLarivaar = value;
                    themeBloc.add(ThemeChanged(appSettings: a));
                  },
                ),
                SettingsTile.switchTile(
                  title: const Text('Enable English Translation'),
                  leading: const Icon(Icons.language),
                  initialValue: state.appSettings.enableEnglish,
                  onToggle: (bool value) {
                    AppSettings a = state.appSettings;
                    a.enableEnglish = value;
                    themeBloc.add(ThemeChanged(appSettings: a));
                  },
                ),
                SettingsTile.switchTile(
                  title: const Text('Enable Punjabi Translation'),
                  leading: const Icon(Icons.local_activity),
                  initialValue: state.appSettings.enablePunjabi,
                  onToggle: (bool value) {
                    AppSettings a = state.appSettings;
                    a.enablePunjabi = value;
                    themeBloc.add(ThemeChanged(appSettings: a));
                  },
                ),
                SettingsTile(
                  leading: const Icon(Icons.font_download),
                  title: const Text('Font Size'),
                  trailing: DropdownButton<String>(
                    value: state.appSettings.fontScale,
                    items: <String>['Small', 'Normal', 'Medium', 'Large']
                        .map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {
                      AppSettings a = state.appSettings;
                      a.fontScale = _ ?? '';
                      themeBloc.add(ThemeChanged(appSettings: a));
                    },
                  ),
                ),
              ]),
              SettingsSection(
                title: const Text('App Settings'),
                tiles: [
                  SettingsTile.switchTile(
                    title: const Text('Dark Mode'),
                    initialValue: state.appSettings.darkTheme,
                    onToggle: (bool value) {
                      AppSettings a = state.appSettings;
                      a.darkTheme = value;
                      themeBloc.add(ThemeChanged(appSettings: a));
                    },
                  ),
                ],
              )
            ],
          );
        }),
      ),
      body: BlocBuilder<DetailsBloc, DetailsState>(
        builder: (context, state) {
          if (state is DetailStateLoading) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is DetailStateLoaded) {
            return Column(
              children: <Widget>[
                AnimatedContainer(
                  height: appBarIsVisible ? 80.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context),
                    ),
                    elevation: 0,
                    title: Text(state.data.name),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoScrollbar(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.data.baniPunjabi.length,
                      itemBuilder: (_, i) => Column(
                        children: <Widget>[
                          themeBloc.state.appSettings.enableLarivaar && state.data.baniLarivar[i] != ''
                              ? Container(
                                  padding: EdgeInsets.only(
                                      top: state.data.type[i] == 2 ? 30 : 5, bottom: 0),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.8 *
                                        getFontScale(themeBloc
                                            .state.appSettings.fontScale),
                                    text: TextSpan(
                                      children: () {
                                        String text = state.data.baniLarivar[i] ?? '';
                                        List<TextSpan> spans = [];
                                        List<String> parts = text.split(';');
                                        
                                        for (int j = 0; j < parts.length; j++) {
                                          String part = parts[j];
                                          if (part.isEmpty) continue;
                                          
                                          List<String> dotParts = part.split('.');
                                          for (int k = 0; k < dotParts.length; k++) {
                                            String dotPart = dotParts[k];
                                            if (dotPart.isEmpty) continue;
                                            
                                            List<String> words = dotPart.split('\u200b');
                                            if (k == dotParts.length - 1 && j == parts.length - 1) {
                                              spans.add(TextSpan(
                                                text: dotPart,
                                                style: DefaultTextStyle.of(context).style.copyWith(
                                                  color: state.data.type[i] == 2 ? Colors.orange : null
                                                )
                                              ));
                                            } else if (k < dotParts.length - 1) {
                                              if (words.length > 1) {
                                                spans.add(TextSpan(
                                                  text: words.sublist(0, words.length-1).join('\u200b'),
                                                  style: DefaultTextStyle.of(context).style.copyWith(
                                                    color: state.data.type[i] == 2 ? Colors.orange : null
                                                  )
                                                ));
                                              }
                                              spans.add(TextSpan(
                                                text: words.last,
                                                style: TextStyle(color: Colors.blue)
                                              ));
                                            } else {
                                              if (words.length > 1) {
                                                spans.add(TextSpan(
                                                  text: words.sublist(0, words.length-1).join('\u200b'),
                                                  style: DefaultTextStyle.of(context).style.copyWith(
                                                    color: state.data.type[i] == 2 ? Colors.orange : null
                                                  )
                                                ));
                                              }
                                              spans.add(TextSpan(
                                                text: words.last,
                                                style: TextStyle(color: Colors.orange)
                                              ));
                                            }
                                          }
                                        }
                                        return spans;
                                      }(),
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.only(
                                      top: state.data.type[i] == 2 ? 30 : 5, bottom: 10, left: 10, right: 10),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.8 *
                                        getFontScale(themeBloc
                                            .state.appSettings.fontScale),
                                    text: TextSpan(
                                      children: () {
                                        String text = state.data.baniGurmukhi[i] ?? '';
                                        List<TextSpan> spans = [];
                                        List<String> parts = text.split(';');
                                        
                                        for (int j = 0; j < parts.length; j++) {
                                          String part = parts[j];
                                          if (part.isEmpty) continue;
                                          
                                          List<String> dotParts = part.split('.');
                                          for (int k = 0; k < dotParts.length; k++) {
                                            String dotPart = dotParts[k];
                                            if (dotPart.isEmpty) continue;
                                            
                                            List<String> words = dotPart.split(' ');
                                            if (k == dotParts.length - 1 && j == parts.length - 1) {
                                              spans.add(TextSpan(
                                                text: dotPart,
                                                style: DefaultTextStyle.of(context).style.copyWith(
                                                  color: state.data.type[i] == 2 ? Colors.orange : null
                                                )
                                              ));
                                            } else if (k < dotParts.length - 1) {
                                              if (words.length > 1) {
                                                spans.add(TextSpan(
                                                  text: words.sublist(0, words.length-1).join(' ') + ' ',
                                                  style: DefaultTextStyle.of(context).style.copyWith(
                                                    color: state.data.type[i] == 2 ? Colors.orange : null
                                                  )
                                                ));
                                              }
                                              spans.add(TextSpan(
                                                text: words.last,
                                                style: TextStyle(color: Colors.blue)
                                              ));
                                            } else {
                                              if (words.length > 1) {
                                                spans.add(TextSpan(
                                                  text: words.sublist(0, words.length-1).join(' ') + ' ',
                                                  style: DefaultTextStyle.of(context).style.copyWith(
                                                    color: state.data.type[i] == 2 ? Colors.orange : null
                                                  )
                                                ));
                                              }
                                              spans.add(TextSpan(
                                                text: words.last,
                                                style: TextStyle(color: Colors.orange)
                                              ));
                                            }
                                          }
                                        }
                                        return spans;
                                      }(),
                                    ),
                                  ),
                                ),
                          themeBloc.state.appSettings.enablePunjabi && state.data.baniPunjabi[i] != ''
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 0),
                                  child: Text(
                                    state.data.baniPunjabi[i] ?? '',
                                    textAlign: TextAlign.center,
                                    textScaleFactor: (1 *
                                            getFontScale(themeBloc
                                                .state.appSettings.fontScale))
                                        .toDouble(),
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                )
                              : Container(),
                          themeBloc.state.appSettings.enableEnglish && state.data.baniEnglish[i] != ''
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 0),
                                  child: Text(
                                    state.data.baniEnglish[i] ?? '',
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 0.9 *
                                        getFontScale(themeBloc
                                            .state.appSettings.fontScale),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is DetailStateError) {
            return Center(
              child: Text('Something Went Wrong While Loading Data'),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
