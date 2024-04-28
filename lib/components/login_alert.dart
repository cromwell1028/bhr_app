import 'package:flutter/material.dart';

class LoginAlert extends StatelessWidget {
  final text;
  const LoginAlert({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: const Text("Sikertelen bejelentkezés"),
      content: Text(text),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: (){
            Navigator.pop(context);
            }, 
          child: const Text("Rendben")),
      ]
    );
  }
}