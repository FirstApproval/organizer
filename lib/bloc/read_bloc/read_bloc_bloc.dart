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
    on<ReadBlocEvent>((event, emit) async {
      event.map(
        started: (event) async {
          await _openFile(event, emit);
          emit.isDone;
          emit(ReadBlocState.initial(card));
        },
      );
    });
  }

  Future<void> _openFile(_Started event, Emitter<ReadBlocState> emit) async {
    String? file = await fileManager.getFile();
    if (file == null) return;
    String result = await File(file).readAsString();
    card = ExperimentCardTextFields.fromJson(jsonDecode(result));
  }
}
