import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data.dart';
import '../model.dart';

part 'hukam_event.dart';
part 'hukam_state.dart';

class HukamBloc extends Bloc<HukamEvent, HukamState> {
  ApiClass api = ApiClass();

  HukamBloc() : super(HukamStateDefault()) {
    on<HukamEventLoading>((event, emit) async {
      try {
        emit(HukamStateLoading());
        Hukam result = await api.getHukam();
        emit(HukamStateLoaded(data: result));
      } catch (e) {
        print(e);
        emit(HukamStateError());
      }
    });
  }
}
