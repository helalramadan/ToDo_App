import 'package:flutter/material.dart';
import 'package:todo_app/companent.dart';
import 'package:todo_app/constans.dart';

class Task_Screen extends StatelessWidget {
  @override
  @override
  Widget build(context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) =>
          BuildTaske(taskes[index]),
      separatorBuilder: (context, int index) => Container(
        height: 1,
        width: double.infinity,
        color: Colors.grey,
      ),
      itemCount: taskes.length,
    );
  }
}
