import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'companent.dart';
import 'cubit/cubit.dart';
import 'cubit/cubitstat.dart';

class Home extends StatelessWidget {
  @override
  var scafoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  // List<Map> taskes = []; error
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => To_Cubit()..creatDataBase(),
      child: BlocConsumer<To_Cubit, To_State>(
        listener: (BuildContext context, state) {
          if (state is InsertDataBase_state) {
            Navigator.pop(context);

            titleController.text = "";

            dateController.text = "";

            timeController.text = "";
          }
        },
        builder: (BuildContext context, state) {
          return Scaffold(
            key: scafoldKey,
            appBar: AppBar(
              title: const Text("To Do App"),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (To_Cubit.get(context).isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    To_Cubit.get(context).insertDataBase(
                        date: dateController.text,
                        time: timeController.text,
                        title: titleController.text);
                  }
                } else {
                  scafoldKey.currentState!
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
                                                  lastDate: DateTime.parse(
                                                      "2025-04-12"))
                                              .then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          }).catchError((error) {});
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    To_Cubit.get(context).changeBouttonSheet(false, Icons.edit);
                  });
                  To_Cubit.get(context).changeBouttonSheet(true, Icons.add);
                }
              },
              child: Icon(To_Cubit.get(context).fabicon),
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  To_Cubit.get(context).change(index);
                },
                currentIndex: To_Cubit.get(context).curentindex,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.task), label: "Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done_outline_rounded), label: "Done"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: "Archive"),
                ]),
            body:
                To_Cubit.get(context).Screen[To_Cubit.get(context).curentindex],
          );
        },
      ),
    );
  }
}
