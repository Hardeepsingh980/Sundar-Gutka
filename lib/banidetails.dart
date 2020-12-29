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
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        fabIsVisible = _scrollController.position.userScrollDirection ==
            ScrollDirection.forward;
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
            onPressed: null,
            icon: IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(seconds: 500 * initialSpeed),
                    curve: Curves.elasticOut,
                  );
                }),
            label: CupertinoSlider(
              value: initialSpeed.toDouble(),
              onChanged: (v) {
                setState(() {
                  print(500 * initialSpeed.toInt());

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
              SettingsSection(title: 'Gurbani Settings', tiles: [
                SettingsTile.switchTile(
                  title: 'Enable Larivaar',
                  leading: Icon(Icons.ac_unit),
                  switchValue: state.appSettings.enableLarivaar,
                  onToggle: (bool value) {
                    AppSettings a = state.appSettings;
                    a.enableLarivaar = value;
                    themeBloc.add(ThemeChanged(appSettings: a));
                  },
                ),
                SettingsTile.switchTile(
                  title: 'Enable English Translation',
                  leading: Icon(Icons.language),
                  switchValue: state.appSettings.enableEnglish,
                  onToggle: (bool value) {
                    AppSettings a = state.appSettings;
                    a.enableEnglish = value;
                    themeBloc.add(ThemeChanged(appSettings: a));
                  },
                ),
                SettingsTile.switchTile(
                  title: 'Enable Punjabi Translation',
                  leading: Icon(Icons.local_activity),
                  switchValue: state.appSettings.enablePunjabi,
                  onToggle: (bool value) {
                    AppSettings a = state.appSettings;
                    a.enablePunjabi = value;
                    themeBloc.add(ThemeChanged(appSettings: a));
                  },
                ),
                SettingsTile(
                  leading: Icon(Icons.font_download),
                  title: 'Font Size',
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
                      a.fontScale = _;
                      themeBloc.add(ThemeChanged(appSettings: a));
                    },
                  ),
                ),
              ]),
              SettingsSection(
                title: 'App Settings',
                tiles: [
                  SettingsTile.switchTile(
                      title: 'Dark Mode',
                      onToggle: (bool value) {
                        AppSettings a = state.appSettings;
                        a.darkTheme = value;
                        themeBloc.add(ThemeChanged(appSettings: a));
                      },
                      switchValue: state.appSettings.darkTheme)
                ],
              )
            ],
          );
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<DetailsBloc, DetailsState>(
          builder: (context, state) {
            if (state is DetailStateLoading) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state is DetailStateLoaded) {
              return CupertinoScrollbar(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.data.baniPunjabi.length,
                  itemBuilder: (_, i) => Column(
                    children: <Widget>[
                      themeBloc.state.appSettings.enableLarivaar
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              child: Text(
                                state.data.baniLarivar[i] ?? '',
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.8 *
                                    getFontScale(
                                        themeBloc.state.appSettings.fontScale),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              child: Text(
                                state.data.baniGurmukhi[i] ?? '',
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.8 *
                                    getFontScale(
                                        themeBloc.state.appSettings.fontScale),
                              ),
                            ),
                      themeBloc.state.appSettings.enablePunjabi
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
                      themeBloc.state.appSettings.enableEnglish
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              child: Text(
                                state.data.baniEnglish[i] ?? '',
                                textAlign: TextAlign.center,
                                textScaleFactor: 0.9 *
                                    getFontScale(
                                        themeBloc.state.appSettings.fontScale),
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              );
            } else if (state is DetailStateError) {
              return Center(
                child: Text('Something Went Wrong While Loading Data'),
              );
            }
          },
        ),
      ),
    );
  }
}
