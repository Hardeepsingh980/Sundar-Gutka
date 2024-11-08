part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class ThemeInitialEvent extends ThemeEvent {
  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return 'ThemeInitialEvent';
  }
}

class ThemeChanged extends ThemeEvent {
  final AppSettings appSettings;

  ThemeChanged({
    required this.appSettings,
  });

  @override
  List<Object?> get props => [appSettings];

  @override
  String toString() {
    return 'ThemeChanged';
  }
}
