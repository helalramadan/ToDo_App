import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/archive.dart';
import 'package:todo_app/done.dart';
import 'package:todo_app/task.dart';

import 'cubitstat.dart';

class To_Cubit extends Cubit<To_State> {
  To_Cubit() : super(Inisional_state());

  static To_Cubit get(context) => BlocProvider.of(context);

  int curentindex = 0;
  List<Widget> Screen = [Task_Screen(), Done_Screen(), Archive_Screen()];
  void change(index) {
    curentindex = index;
    emit(Change_state());
  }
}
