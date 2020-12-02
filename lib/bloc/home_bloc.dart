import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../data.dart';
import '../model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  
  ApiClass api = ApiClass();

  HomeBloc(HomeState initialState) : super(initialState);


  HomeState get initialState => HomeStateDefault();
 

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeEventLoading) {
      yield* _mapLoadBaniState(event);
    } else if (event is FavouriteAdded) {
      yield HomeStateLoading();
      List<Bani> result = await api.getBaniList();
      List<Bani> a = await api.addFavourites(event.favourites);
      yield HomeStateLoaded(data: result, favourites: a);
    }
  }

  Stream<HomeState> _mapLoadBaniState(HomeEventLoading event) async* {
    try {
      yield HomeStateLoading();
      List<Bani> result = await api.getBaniList();
      List<Bani> favourites = await api.getInitialFavourites();
      yield HomeStateLoaded(data: result, favourites: favourites);
    } catch (e) {
      yield HomeStateError();
    }
  }
}
