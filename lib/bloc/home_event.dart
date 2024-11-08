part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeEventLoading extends HomeEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'HomeEventLoading';
}

class FavouriteAdded extends HomeEvent {
  final List<Bani> favourites;

  FavouriteAdded({
    required this.favourites,
  });
}