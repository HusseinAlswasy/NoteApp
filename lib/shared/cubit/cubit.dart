import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newtodoapp/modules/ArchivedTasks/ArchivedTasks.dart';
import 'package:newtodoapp/modules/DoneTasks/DoneTasks.dart';
import 'package:newtodoapp/modules/NewTasks/NewTasks.dart';
import 'package:newtodoapp/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeIndexState());
  }

  List<Widget> Screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  List<String> titles = ['NOTE', 'Done Tasks', 'Archived Tasks'];

  bool isBottomSheet = false;
  IconData FabIcon = Icons.edit;

  void changeBottomSheet({
    required bool isShow,
    required IconData iconData,
  }) {
    isBottomSheet = isShow;
    FabIcon = iconData;
    emit(AppChangeState());
  }

  Database? database;

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('Database Created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY , time TEXT ,title TEXT ,date TEXT ,status TEXT)')
          .then((value) {
        print('CREATE Table');
      }).catchError((error) {
        print('Error ${error.toString()}');
      });
    }, onOpen: (database) {
      getFromDatabase(database);
      print('Database Opened');
    }).then((value) {
      database = value;
      emit(AppCreateState());
    });
  }

  void insertToDatabase({
    required String time,
    required String title,
    required String date,
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(time,title,date,status) VALUES("$time","$title","$date","new")',
      )
          .then((value) {
        print('$value Inserted Tables');
        emit(AppInsertState());
        getFromDatabase(database);
      }).catchError((error) {
        print('Error When Inserting ${error.toString()}');
      });
    });
  }

  void getFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id =?',
      ['$status', id],
    ).then((value) {
      getFromDatabase(database);
      emit(AppUpdateState());
    });
  }

  void deleteData({
   required int id,
  })async{
    database!.rawDelete('DELETE FROM tasks WHERE id= ?',[id]

    ).then((value){
      getFromDatabase(database);
      emit(AppDeleteState());
    });
  }
}
