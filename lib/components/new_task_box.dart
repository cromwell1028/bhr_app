
import 'package:flutter/material.dart';
import 'package:bhr_app/components/newtask_textfield.dart';
import 'package:bhr_app/components/add_button.dart';

// ignore: must_be_immutable
class NewTaskBox extends StatefulWidget {
  String nev;
  String gombnev;
  int idx;
  final TextEditingController tasknamecontroller;
  final TextEditingController descriptioncontroller;
  final TextEditingController datecontroller;
  final TextEditingController timecontroller;
  List<Map<String, dynamic>> dropdownitems;
  Map<String?, dynamic>? selecteditem;
  Function( Map<String?, dynamic>?, int)? onsave;
  VoidCallback oncancel;
  NewTaskBox({super.key, required this.idx,required this.nev, required this.gombnev, required this.tasknamecontroller,  required this.descriptioncontroller, required this.datecontroller, required this.timecontroller, required this.oncancel, required this.onsave, required this.dropdownitems, required this.selecteditem});

  @override
  State<NewTaskBox> createState() => _NewTaskBoxState();
}

class _NewTaskBoxState extends State<NewTaskBox> {

  List<String> groupnames = [];
  void initState()
  {
    for(int i = 0; i<widget.dropdownitems.length;i++)
    {
      groupnames.add(widget.dropdownitems[i]["name"]);
    }
    super.initState();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2020), 
      lastDate: DateTime(2100)
      );
      if(picked != null)
      {
        setState(() {
          widget.datecontroller.text = picked.toString().split(" ")[0];
        });
      }
    }

    Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
      );
      if(picked != null)
      {
        setState(() {
          String formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
          widget.timecontroller.text = formattedTime;
        });
      }
    }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      content: Container(
        height: 415,
        width: 320,
        child: Column(
          children: [
            Text(widget.nev,style: TextStyle(color: Colors.white, fontSize: 16)),
            const Align(
                alignment: Alignment.centerLeft, 
                child: 
                Text("Cím:",style: TextStyle(color: Colors.white, fontSize: 14)),
              ),

            TaskTextfield(ctrl: widget.tasknamecontroller),

            const Padding(
              padding:  EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.centerLeft, 
                child: 
                Text("Határidő:",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 14)),
              ),
            ),

            Row(
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: widget.datecontroller,
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      prefixIcon: Icon(Icons.calendar_today)
                    ),
                    readOnly: true,
                    onTap: (){
                      selectDate(context);
                      }
                    ),
                ),

                const SizedBox(width: 10,),

                SizedBox(
                  width: 100,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: widget.timecontroller,
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    readOnly: true,
                    onTap: (){
                      selectTime(context);
                      }
                  ),
                ),

              ],
            ),

            const Padding(
              padding:  EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.centerLeft, 
                child: 
                Text("Csoport:",style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),

            DropdownButton<String>(
              isExpanded: true,
              dropdownColor: const Color.fromARGB(255, 40, 40, 40),
              value: widget.selecteditem!["id"],
              style: const TextStyle(color: Colors.white),
              items: widget.dropdownitems.map
            ((Map<String, dynamic> dropdownStringItem) {
            return DropdownMenuItem<String>(
            value: dropdownStringItem["id"],
            child: Center(child: Text(dropdownStringItem["name"])),
            );
            }).toList(),
            onChanged: (String? item) {
            setState(() {
              widget.selecteditem = widget.dropdownitems.firstWhere((element) => element["id"] == item);
            });
            },
            ),
            
            const Padding(
              padding:  EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.centerLeft, 
                child: 
                Text("Leírás:",style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),

            TaskTextfield(ctrl: widget.descriptioncontroller),

            const SizedBox(height: 20),

            Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AddButton(text: "Mégse", onPressed: widget.oncancel),

              const SizedBox(width: 10),
              
              AddButton(text: widget.gombnev, onPressed: () => widget.onsave!(widget.selecteditem, widget.idx)),

            ],
          )


          ],
        ),
      ),
    );
  }
}