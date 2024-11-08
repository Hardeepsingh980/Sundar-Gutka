import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sundargutka/data.dart';
import 'package:sundargutka/model.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final ApiClass api = ApiClass();

  DetailsBloc() : super(DetailStateInitial()) {
    on<DetailsEventInitial>((event, emit) async {
      try {
        emit(DetailStateLoading());
        BaniContent result = await api.getBaniContent(event.id);
        emit(DetailStateLoaded(data: result));
      } catch (e) {
        print(e);
        emit(DetailStateError());
      }
    });
  }
}
