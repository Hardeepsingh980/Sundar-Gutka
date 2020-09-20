part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  ThemeEvent([List props = const []]) : super(props);
}

class ThemeInitialEvent extends ThemeEvent {
  @override
  String toString() {
    return 'ThemeInitialEvent';
  }
}


class ThemeChanged extends ThemeEvent {
  final AppSettings appSettings;

  ThemeChanged({
    @required this.appSettings,
  }) : super([appSettings]);
}
