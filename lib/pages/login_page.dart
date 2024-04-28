import 'dart:convert';
import 'dart:io';
import 'package:bhr_app/components/my_textfield.dart';
import 'package:bhr_app/components/signin_button.dart';
import 'package:bhr_app/components/login_alert.dart';
import 'package:http/http.dart' as http;
import 'package:bhr_app/pages/task_page.dart';
import 'package:flutter/material.dart';
import 'package:bhr_app/globals.dart' as globals;

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late TextEditingController usernamecontroller;
  late TextEditingController passwordcontroller;
  int statuscode = 0;
  String response = "";

  @override
  void initState() {
    super.initState();
    usernamecontroller = TextEditingController();
    passwordcontroller = TextEditingController();
  }

  @override
  void dispose() {
    usernamecontroller.dispose();    
    passwordcontroller.dispose();
    super.dispose();
  }

  void resettext()
  {
    setState(() {
      usernamecontroller.text = "";
      passwordcontroller.text = "";
    });
  }

  void loginerror(String toWrite)
  {
    showDialog(
      context: context, 
      builder: (context)
      {
        return LoginAlert(text: toWrite);
      }
    );
  }
 
  @override
  Widget build(BuildContext context) {

    void signUserIn()
    {
      http.post(Uri.parse(globals.httplink+'/api/auth/login'),headers: {"Content-Type": "application/json"},
      body:jsonEncode({"username": usernamecontroller.text, "password": passwordcontroller.text,  "persistent": true} ))
      .then((value) => {setState(() {
        globals.token = value.headers[HttpHeaders.authorizationHeader].toString();
        statuscode = value.statusCode;
        response = value.body;
      }),
        if(statuscode == 200)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TaskPage())),
          resettext(),
        }
        else if(statuscode == 401)
        {
          loginerror(response)
        }
        else if(statuscode == 400)
        {
          loginerror("Nem töltötte ki az összes mezőt!")
        }
        else
        {
          loginerror("A rendszerben hiba lépett fel!")
        }
        }
      );
    }


    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      body: SafeArea(
        child: Column(  
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 100, top: 100, right: 100, bottom: 50),
              child: Image(image: AssetImage('assets/bhrlogo.png')),
            ),

            const Padding(
              padding:  EdgeInsets.only(left: 30, right: 30),
              child: Align(
                alignment: Alignment.centerLeft, 
                child: 
                Text("Felhasználónév:",style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),

            MyTextField(pw: false, ctrl: usernamecontroller),

            const SizedBox(height: 10),

            const Padding(
              padding:  EdgeInsets.only(left: 30, right: 30),
              child: Align(
                alignment: Alignment.centerLeft, 
                child: 
                Text("Jelszó:",style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),

            MyTextField(pw: true, ctrl: passwordcontroller),

            const SizedBox(height: 20),

            SignInButton(
              onTap: signUserIn,
            ),

          ],
          ),
      )
    );
  }
}