import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newtodoapp/shared/cubit/cubit.dart';
import 'package:newtodoapp/shared/cubit/states.dart';
import '../../shared/componentes/Componenets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return TasksBuilder(tasks: tasks);
      },
    );
  }
}
