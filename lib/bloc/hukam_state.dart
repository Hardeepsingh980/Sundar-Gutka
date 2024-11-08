part of 'hukam_bloc.dart';

abstract class HukamState extends Equatable {
  const HukamState();
}

class HukamStateDefault extends HukamState {
  @override
  List<Object?> get props => [];

  @override
  String toString() => 'HukamStateDefault';
}

class HukamStateLoading extends HukamState {
  @override
  List<Object?> get props => [];

  @override
  String toString() => 'HukamStateLoading';
}

class HukamStateError extends HukamState {
  @override
  List<Object?> get props => [];

  @override
  String toString() => 'HukamStateError';
}

class HukamStateLoaded extends HukamState {
  final Hukam data;

  HukamStateLoaded({required this.data});

  @override
  List<Object?> get props => [data];

  @override
  String toString() => 'HukamStateLoaded';
}