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
  List<Map> newTaskes = [];
  List<Map> doneTaskes = [];
  List<Map> arcivedTaskes = [];

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
      getDataBase(dataBase);
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
  }) {
    dataBase.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO taskes (titel,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value insert data base in done');
        emit(InsertDataBase_state());
        getDataBase(dataBase);
      }).catchError((error) {
        print("error when insert database ${error.toString()}");
      });
    });
  }

  void getDataBase(dataBase) {
    // newTaskes = [];
    // doneTaskes = [];
    // arcivedTaskes = [];
    emit(GetDataBase_state());
    dataBase.rawQuery('SELECT * FROM taskes').then((value) {
      value.forEach((Element) {
        if (Element["status"] == "new") {
          newTaskes.add(Element);
        } else if (Element["status"] == "done") {
          doneTaskes.add(Element);
        } else {
          arcivedTaskes.add(Element);
        }
      });
    });
  }

  bool isBottomSheetShown = false;
  IconData fabicon = Icons.edit;

  void changeBouttonSheet(bool issheet, IconData icon) {
    isBottomSheetShown = issheet;
    fabicon = icon;
    emit(Change_state());
  }

  void UpdateDataBase({
    required String status,
    required int id,
  }) {
    dataBase.rawUpdate('UPDATE taskes SET status = ? WHERE id = ?',
        [status, id]).then((value) {
      emit(UpdateDataBase_state());
      getDataBase(dataBase);
    });
  }

  void DeletDataBase({
    required int id,
  }) {
    dataBase.rawDelete('DELETE FROM taskes WHERE id = ?', [id]).then((value) {
      emit(DeletDataBase_state());
      getDataBase(dataBase);
    });
  }
}
