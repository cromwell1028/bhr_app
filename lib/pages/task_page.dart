import 'dart:convert';
import 'dart:io';
import 'dart:math';
import "package:bhr_app/components/new_task_box.dart";
import "package:bhr_app/components/task_tile.dart";
import 'package:bhr_app/pages/chat_page.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:bhr_app/globals.dart' as globals;

class TaskPage extends StatefulWidget {
  
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final tasknamecontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final timecontroller = TextEditingController();

  List<Map<String, dynamic>> groups = [];
  Map<String, dynamic> actualGroup = {};
  Map<String, dynamic> actualchatGroup = {};

  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> tiletasks = [];
  bool keszon = false;

  void fetchTasks()
  {
    http.get(Uri.parse(globals.httplink+'/api/tasks?showDone=true&showNotDone=true'),
      headers: {"Content-Type": "application/json", "Authorization": globals.token})
      .then((value) => {setState(() {
        tasks = jsonDecode(value.body).cast<Map<String, dynamic>>();
        tiletasks = tasks.where((element) => element["done"] == false).toList();
      }),}
      );
  }

  void fetchGroups()
  {
      http.get(Uri.parse(globals.httplink+'/api/groups'),
      headers: {"Content-Type": "application/json", "Authorization": globals.token})
      .then((value) => {setState(() {
        groups = jsonDecode(value.body).cast<Map<String, dynamic>>();
        actualGroup = groups[0];
        actualchatGroup = groups[0];
      }),}
      );
  }

  void initState()
  {
      fetchTasks();
      fetchGroups();
      super.initState();
  }

  void resetList()
  {
      tiletasks = tasks.where((element) => element["done"] == true).toList();
  }

  void swchanged(bool a)
  {
    setState(() {
      keszon = a;
    });
    if(keszon == true) resetList();
    else{
      tiletasks = tasks.where((element) => element["done"] == false).toList();
    }
  }

  void CheckedIn(bool? comp, int index)
  {
    http.get(Uri.parse(globals.httplink+'/api/tasks/'+tiletasks[index]["id"]+'/setdone/'+(!tiletasks[index]["done"] ? "true" : "false")),
    headers: {"Content-Type": "application/json", "Authorization": globals.token})
      .then((value) => {setState(() {
        tiletasks[index]["done"] = !tiletasks[index]["done"];
        tasks[tasks.indexWhere((element) => element["id"] == tiletasks[index]["id"])]["done"] = tiletasks[index]["done"];
      }),
    });
  }
  
  void cancel()
  {
    Navigator.of(context).pop();
  }

  void save()
  {
    http.post(Uri.parse(globals.httplink+'/api/tasks/create?title='+tasknamecontroller.text+'&description='+descriptioncontroller.text+'&deadline='+datecontroller.text+"T"+timecontroller.text.split(':')[0]+"%3A"+timecontroller.text.split(':')[1]+'&groupId='+actualGroup["id"]),headers: {"Content-Type": "application/json", "Authorization": globals.token} )
      .then((value) => {setState(() {
        fetchTasks();
        resettext();
        Navigator.of(context).pop();
      }),
      }
    );
  }

  void deleteTask(int index)
  {
    http.get(Uri.parse(globals.httplink+'/api/tasks/'+tiletasks[index]["id"].toString()+'/delete'),
    headers: {"Content-Type": "application/json", "Authorization": globals.token})
      .then((value) => {setState(() {
        fetchTasks();
      }),
    });
  }

  void createTask()
  {
    showDialog(
      context: context, 
      builder: (context)
      {
        return NewTaskBox(tasknamecontroller: tasknamecontroller, descriptioncontroller: descriptioncontroller, datecontroller: datecontroller, timecontroller: timecontroller, oncancel: cancel, onsave: save, selecteditem: actualGroup, dropdownitems: groups);
      }
    );
  }

  void resettext()
  {
    setState(() {
      tasknamecontroller.text = "";
      descriptioncontroller.text = "";
      datecontroller.text = "";
      timecontroller.text = "";
    });
  }

  void gotochat()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(selecteditem: actualchatGroup, dropdownitems: groups)));
  }

  void kijelentkezes()
  {
      showDialog(
      context: context, 
      builder: (context)
      {
        return AlertDialog(
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: (){
                Navigator.pop(context);
                }, 
              child: const Text("Mégse")),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              }, 
              child: const Text("Kijelentkezés")),
          ],
          title: const Text("Kijelentkezés"),
          content: const Text("Biztosan kijelentkezel?"),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
          leading: const Padding(
            padding: EdgeInsets.only(left:15),
            child: Image(image: AssetImage('assets/bhrlogo.png')),
          ),
          actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white,),
            tooltip: 'Kijelentkezés',
            onPressed: kijelentkezes,
          ),],

          title: const Text(
              textAlign: TextAlign.center,
              "BoroHFR",
              style: TextStyle(color: Colors.white),
              ),
          ),

      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          tooltip: "Hozzáadás",
          onPressed: createTask,
          child: const Icon(Icons.add, color: Colors.white,),
        ),
      body: 
      Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue
                  ),
                  onPressed: gotochat, 
                  child: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white,),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Elkészített",
                    style: TextStyle(color: Colors.white),
                  ),
                  Switch(
                    activeColor: Colors.blue,
                    value: keszon,
                    onChanged: (value) => swchanged(value),
                  ),
                ],
              ),
            ],
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: tiletasks.length+1,
              itemBuilder:(context, index) {
                  return index == tiletasks.length ?
                  const SizedBox(height: 80) :
                  TaskTile(date: tiletasks[index]["deadline"].split('T')[0],completed: tiletasks[index]["done"], taskname: tiletasks[index]["title"], description: tiletasks[index]["description"], onChanged: (value) => CheckedIn(value, index), delete: () => deleteTask(index));
              }
            ),
          )
        ],
      ),
      
    );
  }
}