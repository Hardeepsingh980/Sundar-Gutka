import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sundargutka/model.dart';

import 'bloc/theme_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeBloc themeBloc = BlocProvider.of<ThemeBloc>(context);

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('With ❤️ from Hardeep Singh', textAlign: TextAlign.center,),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.orange),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
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
    );
  }
}