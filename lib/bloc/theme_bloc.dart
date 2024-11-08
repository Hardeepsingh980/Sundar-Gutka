import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sundargutka/data.dart';
import 'package:sundargutka/model.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ApiClass api = ApiClass();

  ThemeBloc() : super(ThemeStateInitial()) {
    on<ThemeChanged>((event, emit) async {
      emit(ThemeStateLoading());
      AppSettings a = await api.addSettingToPref(event.appSettings);
      emit(ThemeStateLoaded(a));
    });

    on<ThemeInitialEvent>((event, emit) async {
      emit(ThemeStateLoading());
      AppSettings a = await api.getInitialAppSettings();
      emit(ThemeStateLoaded(a));
    });
  }
}
