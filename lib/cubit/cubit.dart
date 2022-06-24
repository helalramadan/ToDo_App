import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/archive.dart';
import 'package:todo_app/done.dart';
import 'package:todo_app/task.dart';

import 'cubitstat.dart';

class To_Cubit extends Cubit<To_State> {
  To_Cubit() : super(Inisional_state());

  static To_Cubit get(context) => BlocProvider.of(context);

  int curentindex = 0;
  List<Map> taskes = [];

  late Database dataBase;
  List<Widget> Screen = [Task_Screen(), Done_Screen(), Archive_Screen()];
  void change(index) {
    curentindex = index;
    emit(Change_state());
  }

  void creatDataBase() {
    openDatabase("hr.db", version: 1, onCreate: (dataBase, version) {
      print("Data Base Created");
      dataBase
          .execute(
              'CREATE TABLE taskes (id INTEGER PRIMARY KEY,titel TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print("Table Created");
      }).catchError((error) {
        print("error when Ceated table ${error.toString()}");
      });
    }, onOpen: (dataBase) {
      getDataBase(dataBase).then((value) {
        taskes = value;
        emit(GetDataBase_state());
      });
      print("Data Base Open");
    }).then((value) {
      dataBase = value;
      emit(CreatDataBase_state());
    });
  }

  insertDataBase({
    required String title,
    required String time,
    required String date,
  }) async {
    await dataBase.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO taskes (titel,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value insert dada base in done');
        emit(InsertDataBase_state());
        getDataBase(dataBase).then((value) {
          taskes = value;
          emit(GetDataBase_state());
        });
      }).catchError((error) {
        print("error when insert database ${error.toString()}");
      });
    });
  }

  Future<List<Map>> getDataBase(dataBase) async {
    return await dataBase.rawQuery('SELECT * FROM taskes');
  }

  bool isBottomSheetShown = false;
  IconData fabicon = Icons.edit;

  void changeBouttonSheet(bool issheet, IconData icon) {
    isBottomSheetShown = issheet;
    fabicon = icon;
    emit(Change_state());
  }
}
