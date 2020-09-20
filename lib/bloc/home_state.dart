part of 'home_bloc.dart';


abstract class HomeState extends Equatable {

  HomeState([List props = const []]) : super(props);
}

class HomeStateDefault extends HomeState {
  @override
  String toString() => 'HomeStateDefault';
}

class HomeStateLoading extends HomeState {
  @override
  String toString() => 'HomeStateLoading';
}

class HomeStateError extends HomeState {
  @override
  String toString() => 'HomeStateError';
}

class HomeStateLoaded extends HomeState {
  final List<Bani> data;

  HomeStateLoaded({this.data});

  @override
  String toString() => 'HomeStateLoaded';
}