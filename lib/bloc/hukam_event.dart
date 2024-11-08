part of 'hukam_bloc.dart';

abstract class HukamEvent extends Equatable {
  const HukamEvent();
}

class HukamEventLoading extends HukamEvent {
  @override
  List<Object?> get props => [];

  @override
  String toString() => 'HukamEventLoading';
}
