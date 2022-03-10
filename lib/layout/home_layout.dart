import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newtodoapp/shared/componentes/Componenets.dart';
import 'package:newtodoapp/shared/cubit/cubit.dart';
import 'package:newtodoapp/shared/cubit/states.dart';

class HomeLoyout extends StatelessWidget {
  HomeLoyout({Key? key}) : super(key: key);

  var scafoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();


  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, AppState state) {
          if(state is AppInsertState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppState state) {
          AppCubit cubit = AppCubit.get(context);
          return Form(
            key: formkey,
            child: Scaffold(
              key: scafoldkey,
              appBar: AppBar(
                backgroundColor: Colors.teal,
                title: Text(
                  cubit.titles[cubit.currentIndex],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading:
                    IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
              ),
              body: cubit.newTasks == 0 ? const Center(child: CircularProgressIndicator()):cubit.Screens[cubit.currentIndex],
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheet) {
                  if(formkey.currentState!.validate()) {
                      cubit.insertToDatabase(
                        time: timeController.text,
                        title: titleController.text,
                        date:dateController.text,
                      );
                      timeController.text = '';
                      titleController.text = '';
                      dateController.text = '';
                      //cubit.getFromDatabase(cubit.database);
                        cubit.changeBottomSheet(isShow: false, iconData: Icons.edit);
                    }
                  } else
                   {
                    scafoldkey.currentState!.showBottomSheet(
                      (context) => Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            deafultTextFormFeiled(
                              controller: titleController,
                              OnTap: (){},
                              onSubmit: (String? value){},
                              keyboard: TextInputType.text,
                              validate: (String? value){
                                if(value!.isEmpty){
                                  return 'Title must be not empty';
                                }
                                return null;
                              },
                              hint: 'Task Title',
                              label: 'Task Title',
                              prefix: Icons.title,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            deafultTextFormFeiled(
                              controller: timeController,
                              onSubmit: (String? value){},
                              keyboard: TextInputType.datetime,
                              validate: (String? value){
                                if(value!.isEmpty){
                                  return 'Time must be not empty';
                                }
                              },
                              OnTap: ()
                              {
                                showTimePicker(
                                    context: context,
                                    initialTime:TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text=value!.format(context).toString();
                                  print(value.format(context));
                                });
                              },
                              hint: 'Time Title',
                              label: 'Time Title',
                              prefix: Icons.watch_later_outlined,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            deafultTextFormFeiled(
                              controller: dateController,
                              onSubmit: (String? value){},
                              keyboard: TextInputType.datetime,
                              validate: (String? value){
                                if(value!.isEmpty){
                                  return 'Date must be not empty';
                                }
                              },
                              OnTap: ()
                              {
                               showDatePicker(
                                   context: context,
                                   initialDate: DateTime.now(),
                                   firstDate: DateTime.now(),
                                   lastDate: DateTime.parse('2022-04-08'),
                               ).then((value){
                                 dateController.text=DateFormat.yMMMd().format(value!);
                                print(DateFormat.yMMMd().format(value));
                               });
                              },
                              hint: 'Date Title',
                              label: 'Date Title',
                              prefix: Icons.calendar_today,
                            ),
                          ],
                        ),
                      ),
                    ).closed.then((value) {
                      cubit.changeBottomSheet(isShow: false, iconData: Icons.edit);
                    });
                    cubit.changeBottomSheet(isShow: true, iconData: Icons.add);
                  }
                },
                child: Icon(
                  cubit.FabIcon,
                ),
                backgroundColor: Colors.teal,
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_box_rounded,
                    ),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_rounded,
                    ),
                    label: 'Archived',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
