import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bhr_app/globals.dart' as globals;

class MyTextField extends StatelessWidget {
  final bool pw;
  final TextEditingController ctrl;
  const MyTextField({super.key, required this.pw, required this.ctrl,});
  
  @override
  Widget build(BuildContext context) {
      return  Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Theme(
          data: ThemeData(
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.blue,
              selectionColor: Colors.blue,
              selectionHandleColor: Colors.blue,
            )
          ),
          child: TextField(
            controller: ctrl,
            obscureText: pw,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
    );
  }
}