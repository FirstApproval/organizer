import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:first_approval_app/cubit/FileCubit/file_cubit.dart';
import 'package:first_approval_app/models/experiment_card_models/card_text_fields.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'read_bloc_event.dart';
part 'read_bloc_state.dart';
part 'read_bloc_bloc.freezed.dart';

class ReadBlocBloc extends Bloc<ReadBlocEvent, ReadBlocState> {
  FileManager fileManager;
  ExperimentCardTextFields card;
  ReadBlocBloc(this.fileManager, this.card) : super(_Initial(card)) {
    on<ReadBlocEvent>(
      (event, emit) {
        event.map(
          started: (event) => _openFile(event, emit),
          /// dead code лучше удалять
          // emit.isDone;
          // emit(ReadBlocState.initial(card));
        );
      },
    );
  }

  Future<void> _openFile(_Started event, Emitter<ReadBlocState> emit) async {

    /// работы с файловым менеджером лучше вынести в репозиторий
    /// Future<ExperimentCardTextFields> cardFromFile()
    /// + обернуть в блоке этот метод в try catch - и эмитить стейт с сообщением об ошибке
    /// кейсы: файл не выбран, файл не удалось распарсить -
    /// throw Exception(message) в репо, а блок в try catch их ловит: on Exception
    String? file = await fileManager.getFile();
    if (file == null) return;
    String result = await File(file).readAsString();
    card = ExperimentCardTextFields.fromJson(jsonDecode(result));
    if (isClosed) {
      emit(ReadBlocState.initial(card));
    }
    ///от принтов избавляемся: испольщуем debugPrint или log
    print(card);
  }
}
