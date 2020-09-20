import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sundargutka/data.dart';
import 'package:sundargutka/model.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {

  ApiClass api = ApiClass();

  DetailsBloc() : super(DetailStateLoading());

  @override
  Stream<DetailsState> mapEventToState(
    DetailsEvent event,
  ) async* {
    if (event is DetailsEventInitial) {
      yield* _mapLoadBaniContentState(event);
    }
  }

  Stream<DetailsState> _mapLoadBaniContentState(DetailsEventInitial event) async* {
    // try {
      yield DetailStateLoading();
      BaniContent result = await api.getBaniContent(event.id);
      yield DetailStateLoaded(data: result);
    // } catch (e) {
    //   yield DetailStateError();
    // }
  }

}
