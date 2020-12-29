import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../data.dart';
import '../model.dart';

part 'hukam_event.dart';
part 'hukam_state.dart';

class HukamBloc extends Bloc<HukamEvent, HukamState> {
  
  ApiClass api = ApiClass();

  HukamBloc(HukamState initialState) : super(initialState);


  HukamState get initialState => HukamStateDefault();
 

  @override
  Stream<HukamState> mapEventToState(HukamEvent event) async* {
    if (event is HukamEventLoading) {
      yield* _mapLoadBaniState(event);
    }
  }

  Stream<HukamState> _mapLoadBaniState(HukamEventLoading event) async* {
    try {
      yield HukamStateLoading();
      Hukam result = await api.getHukam();
      yield HukamStateLoaded(data: result);
    } catch (e) {
      yield HukamStateError();
    }
  }
}
