import 'package:flutter/material.dart';

class TaskTextfield extends StatelessWidget {
  final TextEditingController ctrl;
  const TaskTextfield({super.key, required this.ctrl,});
  
  @override
  Widget build(BuildContext context) {
      return Theme(
        data: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.blue,
            selectionColor: Colors.blue,
            selectionHandleColor: Colors.blue,
          )
        ),
        child: TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white, fontSize: 14, height: 1),
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      );
  }
}