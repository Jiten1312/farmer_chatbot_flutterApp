import 'dart:convert';

import 'package:chat_app/api/api.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ચેટ_બૉટ',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'ચેટ_બૉટ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _baseurl = "http://192.168.43.24:5005/webhooks/rest/webhook";
  final GlobalKey<FormState> _ipv4Key = new GlobalKey<FormState>();
  final messageInsert = TextEditingController();
  List<Map> messages = List();

  final GlobalKey<FormState> _chatkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
            child: Form(
              key: _ipv4Key,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: _baseurl,
                    onSaved: (value) {
                      setState(() {
                        this._baseurl = value;
                      });
                    },
                  ),
                  IconButton(
                      icon: Icon(Icons.input),
                      onPressed: () {
                        if (_ipv4Key.currentState.validate()) {
                          _ipv4Key.currentState.save();
                        }
                      })
                ],
              ),
            ),
          ),
        ),
        body: Container(
          child: Column(children: <Widget>[
            Flexible(
                child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) => chat(
                  messages[index]["message"].toString(),
                  messages[index]["data"]),
            )),
            SizedBox(
              height: 20,
            ),
            Divider(
              height: 5.0,
              color: Colors.greenAccent,
            ),
            Container(
              child: ListTile(
                leading: IconButton(icon: Icon(Icons.info), onPressed: null),
                title: Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: messageInsert,
                    decoration: InputDecoration(
                      hintText: 'Enter a Message...',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(220, 220, 220, 1),
                  ),
                ),
                trailing: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      if (messageInsert.text.isEmpty) {
                        print("Null");
                      } else {
                        setState(() {
                          messages.insert(
                              0, {"data": 1, "message": messageInsert.text});
                        });
                        String response =
                            await Api(_baseurl).chat(messageInsert.text);
                        messageInsert.clear();
                        setState(() {
                          messages.insert(0, {"data": 0, "message": response});
                        });
                      }
                    }),
              ),
            )
          ]),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget chat(String message, int data) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment:
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
              ? Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/robot.jpg"),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Bubble(
                radius: Radius.circular(15.0),
                color: data == 0
                    ? Color.fromRGBO(23, 157, 139, 1)
                    : Colors.orangeAccent,
                elevation: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                          child: Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          message,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ))
                    ],
                  ),
                )),
          ),
          data == 1
              ? Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/default.jpg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}