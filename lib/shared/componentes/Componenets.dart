import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:newtodoapp/shared/cubit/cubit.dart';

Widget deafultTextFormFeiled({
  required TextEditingController controller,
  required TextInputType keyboard,
  Function? onSubmit,
  Function? OnTap,
  required Function validate,
  required String label,
  required String hint,
  required IconData prefix,
  IconData? suffix,
  Function? SuffixPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboard,
      onFieldSubmitted: (String? v) {
        onSubmit!(v);
      },
      onTap: () {
        OnTap!();
      },
      validator: (value) {
        return validate(value);
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefix),
        suffixIcon: Icon(suffix),
        border: const OutlineInputBorder(),
      ),
    );

Widget BuildTaskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
   AppCubit.get(context).deleteData(id: model['id']);
  },
  child:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(

          children: [

            CircleAvatar(

              backgroundColor: Colors.teal,

              radius: 38,

              child: Text(

                '${model['time']}',

                style: const TextStyle(

                  fontSize: 20,

                  fontWeight: FontWeight.bold,

                  color: Colors.white,

                ),

              ),

            ),

            const SizedBox(

              width: 20,

            ),

            Expanded(

              child: Column(

                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(

                    '${model['title']}',

                    style: const TextStyle(

                      fontSize: 20,

                      fontWeight: FontWeight.bold,

                      color: Colors.teal,

                    ),

                  ),

                  const SizedBox(

                    height: 3,

                  ),

                  Text(

                    '${model['date']}',

                    style: const TextStyle(

                      fontSize: 15,

                      color: Colors.grey,

                    ),

                  ),

                ],

              ),

            ),

            const SizedBox(

              width: 20,

            ),

            IconButton(

              onPressed: () {

                AppCubit.get(context).updateData(status: 'done', id: model['id']);

              },

              icon: const Icon(

                Icons.check_box_rounded,

                color: Colors.green,

              ),

            ),

            IconButton(

              onPressed: () {

                AppCubit.get(context)

                    .updateData(status: 'Archived', id: model['id']);

              },

              icon: const Icon(

                Icons.archive_rounded,

                color: Colors.black45,

              ),

            ),

          ],

        ),

      ),
);

Widget TasksBuilder({
  required List<Map> tasks,
})=> ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) =>
        BuildTaskItem(tasks[index], context),
    separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20,
      ),
      child: Container(
        width: double.infinity,
        color: Colors.grey[300],
        height: 1.0,
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Center(
        child: Image(
          image: NetworkImage(
              'https://is5-ssl.mzstatic.com/image/thumb/Purple113/v4/c8/05/c8/c805c81b-ea65-24af-ffba-49ba7de09cfa/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-85-220.png/1200x630wa.png'),
        ),
      ),
      Text(
        'Please write your Note',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
);
