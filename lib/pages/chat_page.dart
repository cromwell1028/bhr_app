
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class Message
{
  final String text;
  final DateTime date;
  final bool myMessage;
  final String sendername;
  Message({required this.text, required this.date, required this.myMessage, required this.sendername});
}

class ChatPage extends StatefulWidget {
  List<Map<String, dynamic>> dropdownitems;
  Map<String?, dynamic>? selecteditem;
  ChatPage({super.key, required this.dropdownitems, required this.selecteditem});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [
    Message(text: "Tesztüzenet1", date: DateTime.parse("2024-03-20"), myMessage: true, sendername: "testuser1"),
    Message(text: "Tesztüzenet2", date: DateTime.parse("2024-03-20"), myMessage: false, sendername: "testuser2"),
  ].reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,

          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
          ),

          title: const Text(
              textAlign: TextAlign.center,
              "Chat",
              style: TextStyle(color: Colors.white),
              ),
          ),
          body: Column(
            children: [
            Container(
              color: const Color.fromARGB(255, 200, 200, 200),
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: const Color.fromARGB(255, 200, 200, 200),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: const Color.fromARGB(255, 200, 200, 200),
                  value: widget.selecteditem!["id"],
                  style: const TextStyle(color: Colors.black),
                  items: widget.dropdownitems.map((Map<String, dynamic> dropdownStringItem) {
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
              ),
            ),

            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 40, 40, 40),
                child: GroupedListView<Message, DateTime>(
                  stickyHeaderBackgroundColor: const Color.fromARGB(255, 40, 40, 40),
                  elements: messages,
                  padding: const EdgeInsets.all(6),
                  reverse: true,
                  order: GroupedListOrder.DESC,
                  groupBy: (message) => DateTime(
                    message.date.year,
                    message.date.month,
                    message.date.day,
                  ),
                  groupHeaderBuilder: (Message message) => SizedBox(
                    height: 40,
                    child: Center(
                      child: Card(
                        color: const Color.fromARGB(255, 60, 60, 60),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            DateFormat.yMMMd().format(message.date),
                            style: const TextStyle(color: Colors.white),
                          ),
                          ),
                      ),
                    ),
                  ),
                  itemBuilder: (context, Message message) => Align(
                    alignment: message.myMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      children: [
                        Text(
                          message.sendername == "testuser1" ? "" : message.sendername,
                          style: const TextStyle(color: Color.fromARGB(255, 200, 200, 200), fontSize: 12),
                        ),

                        Card(
                          color: message.myMessage ? Colors.lightBlue : Colors.white,
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(message.text),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: const Color.fromARGB(255, 200, 200, 200),  
              child: Row(
                children: [
                  const Flexible(
                    child: TextField(
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(10),hintText: "Ide írd az üzenetet"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                      child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                      ),
                      onPressed: () => {}, 
                      child: const Icon(Icons.send, color: Colors.white,),
                      
                  ),
                ),
                ],
              ),
            )
          ]
          ),
    );
  }
}