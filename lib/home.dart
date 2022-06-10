import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/archive.dart';
import 'package:todo_app/companent.dart';
import 'package:todo_app/done.dart';
import 'package:todo_app/task.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int curentindex = 0;
  late Database dataBase;
  var scafoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;

  List<Map> taskes = [];
  List<Widget> Screen = [Task_Screen(), Done_Screen(), Archive_Screen()];
  IconData fabicon = Icons.edit;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    creatDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
        title: const Text("To Do App"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState()!.validate()) {
              insertDataBase(
                      date: dateController.text,
                      time: timeController.text,
                      title: titleController.text)
                  .then((value) {
                Navigator.pop(context);
                isBottomSheetShown = false;
                setState(() {
                  fabicon = Icons.edit;
                });
              }).catchError((erroe) {});
            }
          } else {
            scafoldKey
                .currentState()!
                .showBottomSheet((context) => Container(
                      color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defultTextFormFild(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return " Title Must Not Be Empty ";
                                    }
                                  },
                                  lable: "Titel",
                                  prefix: Icons.title,
                                  onTap: () {}),
                              const SizedBox(
                                height: 10.0,
                              ),
                              defultTextFormFild(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return " Time Must Not Be Empty ";
                                    }
                                  },
                                  lable: "Time",
                                  prefix: Icons.watch_later_outlined,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context);
                                    });
                                  }),
                              const SizedBox(
                                height: 10.0,
                              ),
                              defultTextFormFild(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return " Date Must Not Be Empty ";
                                    }
                                  },
                                  lable: "Date",
                                  prefix: Icons.calendar_today,
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse("2025-04-12"))
                                        .then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    }).catchError((error) {});
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ))
                .closed
                .then((value) {
              isBottomSheetShown = false;
              setState(() {
                fabicon = Icons.edit;
              });
            });
            isBottomSheetShown = true;
            setState(() {
              fabicon = Icons.add;
            });
          }
        },
        child: Icon(fabicon),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {});
            curentindex = index;
          },
          currentIndex: curentindex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_outline_rounded), label: "Done"),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive), label: "Archive"),
          ]),
      body: Screen[curentindex],
    );
  }

  void creatDataBase() async {
    dataBase =
        await openDatabase("hr.db", version: 1, onCreate: (dataBase, version) {
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
       setState(() {
         taskes = value;
       });
      });
      print("Data Base Open");
    });
  }

  Future insertDataBase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await dataBase.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO taskes (titel,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value insert dada base in done');
      }).catchError((error) {
        print("error when insert database ${error.toString()}");
      });
    });
  }

  Future<List<Map>> getDataBase(dataBase) async {
    return await dataBase.rawQuery('SELECT * FROM taskes');
  }
}
