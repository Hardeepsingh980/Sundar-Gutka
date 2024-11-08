part of 'details_bloc.dart';

@immutable
abstract class DetailsState extends Equatable {
  const DetailsState();
  
  @override
  List<Object?> get props => [];
}

class DetailStateInitial extends DetailsState {}

class DetailStateLoading extends DetailsState {}

class DetailStateLoaded extends DetailsState {
  final BaniContent data;

  const DetailStateLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class DetailStateError extends DetailsState {}
