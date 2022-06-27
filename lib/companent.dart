import 'package:flutter/material.dart';
import 'package:todo_app/cubit/cubit.dart';

Widget defultTextFormFild({
  required TextEditingController controller,
  required TextInputType type,
  bool isPassword = false,
  required Function validator,
  Function? onSubmit,
  Function? onChage,
  Function? onTap,
  required String lable,
  IconData? prefix,
  IconData? suffix,
  Function? fsuffix,
}) =>
    TextFormField(
      validator: (value) => validator(value),
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onTap: () {
        onTap!();
      },
      onFieldSubmitted: onSubmit != null ? (s) => onSubmit(s) : null,
      onChanged: onChage != null ? (s) => onChage(s) : null,
      decoration: InputDecoration(
        labelText: lable,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: IconButton(
          icon: Icon(suffix),
          onPressed: () {
            fsuffix!();
          },
        ),
        border: const OutlineInputBorder(),
      ),
    );
Widget BuildTaske(Map model, context) => Dismissible(
      key: Key(model["id"].toString()),
      onDismissed: (direction) {
        To_Cubit.get(context).DeletDataBase(id: model["id"]);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['titel']}',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            IconButton(
              iconSize: 30.0,
              onPressed: () {
                To_Cubit.get(context)
                    .UpdateDataBase(status: "done", id: model["id"]);
              },
              icon: const Icon(
                Icons.check_box,
                color: Color.fromARGB(255, 0, 140, 255),
              ),
            ),
            IconButton(
              onPressed: () {
                To_Cubit.get(context)
                    .UpdateDataBase(status: "arcived", id: model["id"]);
              },
              iconSize: 30.0,
              icon: const Icon(
                Icons.archive,
                color: Colors.black38,
              ),
            )
          ],
        ),
      ),
    );
