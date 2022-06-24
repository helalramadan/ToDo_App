import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/companent.dart';
import 'package:todo_app/cubit/cubit.dart';

class Task_Screen extends StatelessWidget {
  @override
  // To_Cubit taskes = To_Cubit.get(context);
  Widget build(context) {
    return BlocConsumer(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (BuildContext context, int index) =>
              BuildTaske(To_Cubit.get(context).taskes[index]),
          separatorBuilder: (context, int index) => Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey,
          ),
          itemCount: To_Cubit.get(context).taskes.length,
        );
      },
    );
  }
}
