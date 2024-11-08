import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sundargutka/model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/theme_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeBloc themeBloc = BlocProvider.of<ThemeBloc>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
            SettingsSection(
              title: const Text('Support'),
              tiles: [
                SettingsTile(
                  title: const Text('Rate Us on Play Store'),
                  leading: Icon(Icons.star),
                  onPressed: (BuildContext context) async {
                    final InAppReview _inAppReview = InAppReview.instance;
                    if (await _inAppReview.isAvailable()) {
                      _inAppReview.openStoreListing();
                    }
                  },
                  enabled: true,
                ),
                SettingsTile(
                  title: const Text('Support Us'),
                  leading: Icon(Icons.support),
                  onPressed: (BuildContext context) async {
                    String url = 'https://buymeacoffee.com/hardeep';
                    try {
                      // if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      // } else {
                      //   throw 'Could not launch $url';
                      // }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not open link')),
                      );
                    }
                  },
                  enabled: true,
                ),
              ],
            ),
            SettingsSection(title: const Text('Gurbani Settings'), tiles: [
              SettingsTile.switchTile(
                title: const Text('Enable Larivaar')  ,
                leading: Icon(CupertinoIcons.loop),
                initialValue: state.appSettings.enableLarivaar,
                onToggle: (bool value) {
                  AppSettings a = state.appSettings;
                  a.enableLarivaar = value;
                  themeBloc.add(ThemeChanged(appSettings: a));
                },
              ),
              SettingsTile.switchTile(
                title: const Text('Enable English Translation'),
                leading: Icon(Icons.language),
                initialValue: state.appSettings.enableEnglish,
                onToggle: (bool value) {
                  AppSettings a = state.appSettings;
                  a.enableEnglish = value;
                  themeBloc.add(ThemeChanged(appSettings: a));
                },
              ),
              SettingsTile.switchTile(
                title: const Text('Enable Punjabi Translation'),
                leading: Icon(Icons.local_activity),
                initialValue: state.appSettings.enablePunjabi,
                onToggle: (bool value) {
                  AppSettings a = state.appSettings;
                  a.enablePunjabi = value;
                  themeBloc.add(ThemeChanged(appSettings: a));
                },
              ),
              SettingsTile(
                leading: Icon(Icons.font_download),
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
                    }),
              ],
            ),
            SettingsSection(
              title: const Text('Notification Settings'),
              tiles: [
                SettingsTile.switchTile(
                  title: const Text('Get Daily Hukamnama Notifications'),
                  leading: Icon(Icons.receipt),
                  initialValue: state.appSettings.getHukam,
                  onToggle: (bool value) {
                    AppSettings a = state.appSettings;
                    a.getHukam = value;
                    themeBloc.add(ThemeChanged(appSettings: a));
                  },
                ),
                SettingsTile.switchTile(
                  title: const Text('Get Gurupurab Notifications'),
                  leading: Icon(Icons.receipt),
                  initialValue: state.appSettings.getGurupurab,
                  onToggle: (bool value) {
                    AppSettings a = state.appSettings;
                    a.getGurupurab = value;
                    themeBloc.add(ThemeChanged(appSettings: a));
                  },
                ),
                SettingsTile.switchTile(
                  title: const Text('Get Test Notifications'),
                  leading: Icon(Icons.receipt),
                  initialValue: state.appSettings.getTest,
                  onToggle: (bool value) {
                    AppSettings a = state.appSettings;
                    a.getTest = value;
                    themeBloc.add(ThemeChanged(appSettings: a));
                  },
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
