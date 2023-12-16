import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'set_dialog_event.dart';
part 'set_dialog_state.dart';

class SetDialogBloc extends Bloc<SetDialogEvent, SetDialogState> {
  SetDialogBloc() : super(SetDialogInitial()) {
    on<SetStartDialogEvent>(setDialog);
    on<SetStartDiffalogEvent>(setinitialDialog);
  }

  Future<void> setDialog(
    SetStartDialogEvent event,
    Emitter<SetDialogState> emit,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('winnerDialog', true);
    emit(SetSuccesState());
  }

  Future<void> setinitialDialog(
    SetStartDiffalogEvent event,
    Emitter<SetDialogState> emit,
  ) async {
    emit(SetDialogInitial());
  }
}
