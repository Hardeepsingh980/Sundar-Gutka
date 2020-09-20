part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  HomeEvent([List props = const []]) : super(props);
}

class HomeEventLoading extends HomeEvent {

  @override
  String toString() => 'HomeEventLoading';
}
