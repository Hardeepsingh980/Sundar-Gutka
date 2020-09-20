import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sundargutka/bloc/details_bloc.dart';

import 'bloc/theme_bloc.dart';
import 'model.dart';

class BaniContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeBloc themeBloc = BlocProvider.of<ThemeBloc>(context);

    return Scaffold(
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
                )
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
                child: CircularProgressIndicator(),
              );
            } else if (state is DetailStateLoaded) {
              return CupertinoScrollbar(
                child: ListView.builder(
                  itemCount: state.data.baniPunjabi.length,
                  itemBuilder: (_, i) => Column(
                    children: <Widget>[
                      themeBloc.state.appSettings.enableLarivaar
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 0),
                              child: Text(
                                state.data.baniLarivar[i],
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.8,
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 0),
                              child: Text(
                                state.data.baniGurmukhi[i],
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.8,
                              ),
                            ),
                      themeBloc.state.appSettings.enablePunjabi
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 0),
                              child: Text(
                                state.data.baniPunjabi[i],
                                textAlign: TextAlign.center,
                                // textScaleFactor: 1,
                                style: TextStyle(color: Colors.orange),
                              ),
                            )
                          : Container(),
                      themeBloc.state.appSettings.enableEnglish
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 0),
                              child: Text(
                                state.data.baniEnglish[i],
                                textAlign: TextAlign.center,
                                textScaleFactor: 0.9,
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