import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'companent.dart';
import 'cubit/cubit.dart';
import 'cubit/cubitstat.dart';

class Done_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<To_Cubit, To_State>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (BuildContext context, int index) => BuildTaske(
            To_Cubit.get(context).doneTaskes[index],
            context,
          ),
          separatorBuilder: (context, int index) => Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey,
          ),
          itemCount: To_Cubit.get(context).doneTaskes.length,
        );
      },
    );
  }
}
