part of 'hukam_bloc.dart';

abstract class HukamEvent extends Equatable {
  HukamEvent([List props = const []]) : super(props);
}

class HukamEventLoading extends HukamEvent {

  @override
  String toString() => 'HukamEventLoading';
}
