import 'package:flutter/material.dart';

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
Widget BuildTaske(Map model) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
           CircleAvatar(
            child: Text('${model['time']}'),
            radius: 40.0,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children:  [
              Text(
                '${model['titel']}',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
'${model['date']}',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
