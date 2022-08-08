// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Mywork extends StatefulWidget {
  const Mywork({Key? key}) : super(key: key);

  @override
  State<Mywork> createState() => _MyworkState();
}

class _MyworkState extends State<Mywork> {
  late SharedPreferences prefs;
  TextEditingController controller = TextEditingController();

  List<String>? works = [];
  List<bool>? ischecked = [false];

  List<String> checking = [];
  check() {
    checking = List<String>.filled(ischecked!.length, 'F');
    for (int j = 0; j < ischecked!.length; j++) {
      if (ischecked![j] == true) {
        checking[j] = 'T';
      }
      print(checking[j]);
    }
  }

  @override
  void initState() {
    retrieve();
    super.initState();
    ischecked = List<bool>.filled(works!.length, false, growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 143, 226, 222),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('TODO APP'),
          actions: [
            IconButton(
                onPressed: () {
                  delete();
                },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ))
          ],
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'Work',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(ischeckedfunction(ischecked!),
                    style: TextStyle(fontWeight: FontWeight.bold))
              ]),
              Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: ListView.builder(
                    itemCount: works!.length,
                    itemBuilder: ((context, index) => CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.black,
                        // tristate: true,
                        value: ischecked?[index],
                        onChanged: (bool? value) {
                          setState(() {
                            ischecked?[index] = value!;
                          });
                          check();
                        },
                        title: Text(
                          works![index],
                          style: TextStyle(
                              decoration: ischecked![index]
                                  ? TextDecoration.lineThrough
                                  : null),
                        )))),
              )
            ])),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Material(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
              side: BorderSide(width: 2)),
          child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () async {
                final myWork = await showDialog(
                    context: context,
                    builder: (BuildContext cont) => AlertDialog(
                          content: TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              labelText: 'Enter Your work here',
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  child: FlatButton(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(cont);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  child: ElevatedButton(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(cont, controller.text);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ));
                if (myWork != null && !myWork.isEmpty) {
                  setState(() {
                    ischecked!.add(false);
                    works!.add(controller.text);
                    save();
                    controller.clear();
                  });
                }
              },
              child: const Icon(Icons.add, color: Colors.black)),
        ));
  }

  ischeckedfunction(List ischeked) {
    int count = 0;
    for (int i = 0; i < ischecked!.length; i++) {
      if (ischecked![i] == false) {
        count++;
      }
    }
    return count.toString();
  }

  save() async {
    prefs = await SharedPreferences.getInstance();

    prefs.setStringList("TodoList", works!);
  }

  retrieve() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("TodoList") != null) {
      works!.addAll(prefs.getStringList("TodoList")!);
      ischecked = List<bool>.filled(works!.length, false, growable: true);

      setState(() {});
    }
  }

  delete() async {
    print('delete function');
    prefs.remove("TodoList");
    prefs = await SharedPreferences.getInstance();

    setState(() {
      works!.clear();
    });
  }

  savebool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("TodoList", true);
  }
}

  
  /*save(works) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList("username", works!);
  }

  retrieve() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString("username")!;
    setState(() {});
  }

  delete() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    name = "";
    setState(() {});
  }
}

 

 showBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: TextFormField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Enter Your work here',
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: FlatButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              backgroundColor: Colors.white,
                              color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      child: ElevatedButton(
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          // newWork = _textEditingController.text;
                          Navigator.of(context).pop();
                          setState(() {
                            works!.insert(
                                works!.length, _textEditingController.text);
                            _textEditingController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ));*/
  





