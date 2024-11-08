part of 'home_bloc.dart';


abstract class HomeState extends Equatable {

  const HomeState();
}

class HomeStateDefault extends HomeState {
  @override
  String toString() => 'HomeStateDefault';
  
  @override
  List<Object?> get props => [];
}

class HomeStateLoading extends HomeState {
  @override
  String toString() => 'HomeStateLoading';

  @override
  List<Object?> get props => [];
}

class HomeStateError extends HomeState {
  @override
  String toString() => 'HomeStateError';

  @override
  List<Object?> get props => [];
}

class HomeStateLoaded extends HomeState {
  final List<Bani> data;
  final List<Bani> favourites;

  HomeStateLoaded({required this.data, required this.favourites});

  @override
  String toString() => 'HomeStateLoaded';

  @override
  List<Object?> get props => [data, favourites];
}