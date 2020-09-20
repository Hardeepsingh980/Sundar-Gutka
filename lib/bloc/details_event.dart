part of 'details_bloc.dart';

abstract class DetailsEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class DetailsEventInitial extends DetailsEvent {

  final int id;

  DetailsEventInitial({this.id});

  @override
  String toString() {
    return 'DetailsEventInitial';
  }
}

