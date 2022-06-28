import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'companent.dart';
import 'cubit/cubit.dart';
import 'cubit/cubitstat.dart';

class Archive_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<To_Cubit, To_State>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: To_Cubit.get(context).arcivedTaskes.isNotEmpty,
          builder: (context) => ListView.separated(
            itemBuilder: (BuildContext context, int index) => BuildTaske(
              To_Cubit.get(context).arcivedTaskes[index],
              context,
            ),
            separatorBuilder: (context, int index) => Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
            itemCount: To_Cubit.get(context).arcivedTaskes.length,
          ),
          fallback: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.architecture_sharp,
                  color: Colors.grey,
                  size: 45.0,
                ),
                Text("hello")
              ],
            ),
          ),
        );
      },
    );
  }
}
