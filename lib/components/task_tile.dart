//import 'dart:html';

import 'package:flutter/material.dart';
// ignore: must_be_immutable
class TaskTile extends StatelessWidget {
  
  final String taskname;
  final String description;
  final bool completed;
  final String date;
  Function(bool?)? onChanged;
  Function() delete;

  TaskTile(
  {
    super.key,
    required this.taskname,
    required this.description,
    required this.completed,
    required this.onChanged,
    required this.date,
    required this.delete
  });

  String popupitem1 = "Részletek";
  String popupitem2 = "Szerkesztés";
  String popupitem3 = "Törlés";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Checkbox
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(value: completed, onChanged: onChanged, activeColor: Colors.blue,),
                    Text(taskname, style: TextStyle(color: Colors.white, decoration: completed ? TextDecoration.lineThrough : TextDecoration.none, decorationColor: Colors.white, fontSize: 16)),
                  ],
                ),
                PopupMenuButton(
                  iconColor: Colors.white,

                  itemBuilder: (context) => [

                  PopupMenuItem(value: popupitem1,child: Text(popupitem1),),

                  PopupMenuItem(value: popupitem2,child: Text(popupitem2),),

                  PopupMenuItem(value: popupitem3, onTap: delete, child: Text(popupitem3)),


                ]
                )
            
              ],
              
            ),

            Align(alignment: Alignment.centerLeft, child: Padding(
              padding: const EdgeInsets.only(left:15,top:4,right:4,bottom:4),
              child: Text(description, style: TextStyle(color: Colors.white, decoration: completed ? TextDecoration.lineThrough : TextDecoration.none, decorationColor: Colors.white, fontSize: 12)),
            )),

            Align(
              alignment: Alignment.bottomRight,
              child:
              Text(
                date,
                style: const TextStyle(color: Colors.white, fontSize: 12)
                ),
            )
          ],
        ),
      ),
    );
  }
}