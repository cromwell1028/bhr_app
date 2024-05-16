import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:signalr_core/signalr_core.dart';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:bhr_app/globals.dart' as globals;

class Message
{
  final String text;
  final DateTime date;
  final bool myMessage;
  final String sendername;
  final String channelId;
  
  Message({required this.text, required this.date, required this.myMessage, required this.sendername, required this.channelId});
}


class ChatPage extends StatefulWidget {
  
  List<Map<String, dynamic>> dropdownitems;
  Map<String?, dynamic>? selecteditem;
  ChatPage({super.key, required this.dropdownitems, required this.selecteditem});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _HttpClient extends http.BaseClient {
  final _httpClient = http.Client();
  final Map<String, String> defaultHeaders;

  _HttpClient({required this.defaultHeaders});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(defaultHeaders);
    return _httpClient.send(request);
  }
}


class _ChatPageState extends State<ChatPage> {

  late TextEditingController msgcontroller = TextEditingController();

  final connection = HubConnectionBuilder()
      .withUrl(
          '${globals.httplink}/hubs/chat',
          HttpConnectionOptions(
            transport: HttpTransportType.webSockets,
            client: _HttpClient(
              defaultHeaders: 
              {"Authorization" : globals.token}
            ),
            logging: (level, message) => print(message),
          )).withAutomaticReconnect()
    .build();

  List<Message> messages = [];

  void initState()
  {
    
    unsubscribe();
    widget.selecteditem = widget.dropdownitems[0];
    subscribe();
    initmessages();
    init();
    super.initState();
  }

  Future<void> init() async
  {
    
    String actualid = "";
    await http.get(Uri.parse(globals.httplink+'/api/userdata/userid'),
      headers: {"Content-Type":"text/plain", "Authorization": globals.token})
      .then((value) => {setState(() {
        actualid = value.body;
        connection.on('ReceiveMessage', (message){
        setState(() {
          messages.add(Message(text: message![3], date: DateTime.parse(message[5].split('T')[0]), myMessage: actualid == message[1] ? true : false,sendername:  message[2], channelId: message[0]));
        });
        });
      connection.start();
      }),}
      );
    
  }

  Future<void> send() async
  {
    await connection.send(methodName: 'SendMessage', args: [widget.selecteditem!["chatId"], msgcontroller.text, []]);
    msgcontroller.text = "";
  }

  Future<void> subscribe() async
  {
    await connection.invoke('SubscribeToConversation', args: [widget.selecteditem!["chatId"]]);
  }

  Future<void> unsubscribe() async
  {
    await connection.invoke('UnsubscribeFromConversation', args: [widget.selecteditem!["chatId"]]);
  }

  Future<void> initmessages() async
  {
    messages = [];
    http.get(Uri.parse(globals.httplink+'/api/chat/'+widget.selecteditem!["chatId"]),
      headers: {"Content-Type": "application/json", "Authorization": globals.token})
      .then((value) => {setState(() {
        List<Map<String, dynamic>> tmpmsg = jsonDecode(value.body).cast<Map<String, dynamic>>();
        for(int i = 0; i<tmpmsg.length;i++)
        {
          messages.add(Message(text: tmpmsg[i]["message"], date: DateTime.parse(tmpmsg[i]["time"].split('T')[0]), myMessage: tmpmsg[i]["isOwn"],sendername:  tmpmsg[i]["sender"], channelId: widget.selecteditem!["chatId"]));
        }
      }),}
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,

          leading: BackButton(
            onPressed: () {
              connection.stop();
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
                      unsubscribe();
                      widget.selecteditem = widget.dropdownitems.firstWhere((element) => element["id"] == item);
                      subscribe();
                      initmessages();
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
                  Flexible(
                    child: TextField(
                      decoration: const InputDecoration(contentPadding: EdgeInsets.all(10),hintText: "Ide írd az üzenetet"),
                      controller: msgcontroller,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                      child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                      ),
                      onPressed: send,
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