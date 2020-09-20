import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sundargutka/data.dart';
import 'package:sundargutka/model.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ApiClass api = ApiClass();

  ThemeBloc() : super(ThemeStateInitial());

  @override
  Future<ThemeState> get initialState async {
    AppSettings a = await api.getInitialAppSettings();
    ThemeState(appSettings: a);
  }

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeChanged) {
      yield ThemeStateLoading();
      AppSettings a = await api.addSettingToPref(event.appSettings);
      yield ThemeStateLoaded(a);
    } else if (event is ThemeInitialEvent) {
      yield ThemeStateLoading();
      AppSettings a = await api.getInitialAppSettings();
      yield ThemeStateLoaded(a);
    }
  }
}
