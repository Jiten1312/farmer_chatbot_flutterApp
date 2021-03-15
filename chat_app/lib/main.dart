import 'package:chat_app/api/api.dart';
import 'package:chat_app/gridbutton.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'dart:math';

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
  bool isLoading = false;
  List<String> buttons = ['પ્લાન્ટ પ્રોટેક્શન', 'ખાતર', 'બજાર માહિતી'];
  List<dynamic> list = [];
  String _baseurl = "http://192.168.43.24:5005";
  String rId = new Random().nextInt(999999999).toString();
  final GlobalKey<FormState> _ipv4Key = new GlobalKey<FormState>();
  final messageInsert = TextEditingController();
  List<Map> messages = List();

  @override
  Widget build(BuildContext context) {
    print(rId);
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
            loadWidget(isLoading),
            Divider(
              height: 5.0,
              color: Colors.greenAccent,
            ),
            Container(
              child: Column(
                children: [
                  getList(),
                  getGrid(),
                  ListTile(
                    leading: IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          String response =
                              await Api(baseurl: _baseurl, rId: rId)
                                  .startForm('Restart');
                          setState(() {
                            isLoading = false;
                            buttons = [
                              'પ્લાન્ટ પ્રોટેક્શન',
                              'ખાતર',
                              'બજાર માહિતી'
                            ];
                            list = [];
                          });
                          messageInsert.clear();
                        }),
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
                              messages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                            });
                            var api = new Api(baseurl: _baseurl, rId: rId);
                            if (messageInsert.text == 'બજાર માહિતી' ||
                                messageInsert.text == 'ખાતર' ||
                                messageInsert.text == 'પ્લાન્ટ પ્રોટેક્શન') {
                              setState(() {
                                isLoading = true;
                              });
                              String response =
                                  await api.startForm(messageInsert.text);
                              messageInsert.clear();
                              setState(() {
                                isLoading = false;
                                list = api.getList();
                                print(list);
                                buttons = [];
                              });
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              String response =
                                  await api.chat(messageInsert.text);
                              messageInsert.clear();
                              setState(() {
                                messages.insert(
                                    0, {"data": 0, "message": response});
                                isLoading = false;
                                list = api.getList();
                                print(list);
                                buttons = [];
                              });
                            }
                          }
                        }),
                  ),
                ],
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

  Widget getGrid() {
    if (this.list.length == 0) {
      return Container();
    } else {
      return Container(
        height: 250,
        child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 8 / 4,
            children: List.generate(list.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      child: RaisedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                            messages
                                .insert(0, {"data": 1, "message": list[index]});
                          });
                          var api = new Api(baseurl: _baseurl, rId: rId);
                          String response = await api.chat(list[index]);
                          setState(() {
                            isLoading = false;
                            list = api.getList();
                          });
                          messageInsert.clear();
                          setState(() {
                            messages
                                .insert(0, {"data": 0, "message": response});
                          });
                        },
                        color: Colors.amber,
                        child: GridButton(text:list[index])
                      ),
                    )),
              );
            })),
      );
    }
  }

  Widget getList() {
    if (buttons.length == 0) {
      return Container();
    } else {
      return Container(
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: buttons.length,
          itemBuilder: (context, index) {
            final text = buttons[index];
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 4),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: 30,
                    width: 120,
                    child: RaisedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                          messages.insert(0, {"data": 1, "message": text});
                        });
                        var api = new Api(baseurl: _baseurl, rId: rId);
                        String response = await api.startForm(text);
                        setState(() {
                          isLoading = false;
                          buttons = [];
                          list = api.getList();
                          print(list);
                        });
                        messageInsert.clear();
                        setState(() {
                          messages.insert(0, {"data": 0, "message": response});
                        });
                      },
                      color: Color.fromARGB(255, 66, 71, 112),
                      child: Text(
                        text,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 15),
                      ),
                    ),
                  )),
            );
          },
        ),
      );
    }
  }

  Widget loadWidget(bool isLoading) {
    if (isLoading) {
      return CircularProgressIndicator();
    } else {
      return Container();
    }
  }
}
