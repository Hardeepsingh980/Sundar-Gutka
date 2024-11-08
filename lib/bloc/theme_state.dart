part of 'theme_bloc.dart';

@immutable
class ThemeState extends Equatable {
  final AppSettings appSettings;

  ThemeState({
    required this.appSettings,
  });

  @override
  List<Object?> get props => [appSettings];
}

class ThemeStateInitial extends ThemeState {
  ThemeStateInitial() : super(appSettings: AppSettings(darkTheme: false, enableLarivaar: false, enableEnglish: false, enablePunjabi: false, getHukam: false, getGurupurab: false, getTest: false, fontScale: ''));

  @override
  String toString() {
    return 'ThemeStateInitial';
  }
}

class ThemeStateLoading extends ThemeState {
  ThemeStateLoading() : super(appSettings: AppSettings(darkTheme: false, enableLarivaar: false, enableEnglish: false, enablePunjabi: false, getHukam: false, getGurupurab: false, getTest: false, fontScale: ''));

  @override
  String toString() {
    return 'ThemeStateLoading';
  }
}

class ThemeStateLoaded extends ThemeState {
  ThemeStateLoaded(AppSettings appSettings) : super(appSettings: appSettings);

  @override
  String toString() {
    return 'ThemeStateLoaded';
  }
}