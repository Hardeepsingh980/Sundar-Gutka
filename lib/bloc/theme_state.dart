part of 'theme_bloc.dart';

@immutable
class ThemeState extends Equatable {
  final AppSettings appSettings;

  ThemeState({
    @required this.appSettings,
  }) : super([appSettings]);

}

class ThemeStateInitial extends ThemeState {

    @override
  String toString() {
    return 'ThemeStateInitial';
  }

}

class ThemeStateLoading extends ThemeState {

    @override
  String toString() {
    return 'ThemeStateLoading';
  }

}

class ThemeStateLoaded extends ThemeState {

  final AppSettings appSettings;

  ThemeStateLoaded(this.appSettings);

    @override
  String toString() {
    return 'ThemeStateLoaded';
  }

}