part of 'details_bloc.dart';

abstract class DetailsState extends Equatable {  

  DetailsState([List props = const []]) : super(props);

}

class StateDefault extends DetailsState {
  @override
  String toString() => 'HomeStateDefault';
}

class DetailStateLoading extends DetailsState {
  @override
  String toString() {
    return 'DetailStateLoading';
  }
}

class DetailStateLoaded extends DetailsState {

  final BaniContent data;

  DetailStateLoaded({this.data});

  @override
  String toString() {
    return 'DetailStateLoaded';
  }
}

class DetailStateError extends DetailsState {
  @override
  String toString() {
    return 'DetailStateError';
  }
}
