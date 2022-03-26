
import 'package:flutter_bloc/flutter_bloc.dart';

part '../states/switch_creation_state.dart';

class SwitchCreationCubit extends Cubit<SwitchCreationState> {

  SwitchCreationCubit() : super(InitialState());

  void changeScreen() {
    var isItemScreen = state.itemScreen;
    isItemScreen ? changeToCategory() : changeToItem();
  }

  void changeToItem(){
    emit(ChangedToItem());
  }

  void changeToCategory(){
    emit(ChangeToCategory());
  }
}
