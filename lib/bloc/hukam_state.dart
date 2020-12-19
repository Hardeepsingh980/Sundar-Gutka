part of 'hukam_bloc.dart';


abstract class HukamState extends Equatable {

  HukamState([List props = const []]) : super(props);
}

class HukamStateDefault extends HukamState {
  @override
  String toString() => 'HukamStateDefault';
}

class HukamStateLoading extends HukamState {
  @override
  String toString() => 'HukameStateLoading';
}

class HukamStateError extends HukamState {
  @override
  String toString() => 'HukamStateError';
}

class HukamStateLoaded extends HukamState {
  final Hukam data;

  HukamStateLoaded({this.data});

  @override
  String toString() => 'HukamStateLoaded';
}