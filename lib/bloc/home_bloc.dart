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

  HomeBloc() : super(HomeStateDefault()) {
    on<HomeEventLoading>((event, emit) async {
      try {
        emit(HomeStateLoading());
        List<Bani> result = await api.getBaniList();
        List<Bani> favourites = await api.getInitialFavourites();
        emit(HomeStateLoaded(data: result, favourites: favourites));
      } catch (e) {
        print(e);
        emit(HomeStateError());
      }
    });

    on<FavouriteAdded>((event, emit) async {
      emit(HomeStateLoading());
      List<Bani> result = await api.getBaniList();
      List<Bani> a = await api.addFavourites(event.favourites);
      emit(HomeStateLoaded(data: result, favourites: a));
    });
  }
}
