import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kursova/pages/welcome.dart';
import 'package:http/http.dart' as http;

class ReaderProfilePage extends StatefulWidget {
  @override
  _ReaderProfilePageState createState() => _ReaderProfilePageState();
}

class _ReaderProfilePageState extends State<ReaderProfilePage> {
  var localBox = Hive.box('local');

  List _reader, _books;

  String id;

  Future<List> _getData() async {
    setState(() {
      id = localBox.get('id') ?? '2';
    });

    var url =
        "https://dbserverproject.000webhostapp.com/reader/get_current_reader.php";
    var data = {
      "id": id,
    };
    var response = await http.post(url, body: data);

    return json.decode(response.body);
  }

  Future<List> _getBooks() async {
    setState(() {
      id = localBox.get('id') ?? '2';
    });

    var url =
        "https://dbserverproject.000webhostapp.com/reader/get_my_books.php";
    var data = {
      "id": id,
    };
    var response = await http.post(url, body: data);

    return json.decode(response.body);
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        children: [
          SizedBox(height: height * 0.04),
          Row(
            children: [
              SizedBox(width: width * 0.04),
              Container(
                padding: EdgeInsets.only(
                    top: height * 0.045,
                    bottom: height * 0.045,
                    left: width * 0.06),
                color: Theme.of(context).dividerColor,
                width: width * 0.91,
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Image.asset(
                            'images/reader.png',
                            scale: width * 0.0052,
                          ),
                          SizedBox(height: height * 0.03),
                          Text(
                            'Читач',
                            style: TextStyle(fontSize: width * 0.055),
                          ),
                          SizedBox(height: height * 0.03),
                          RaisedButton(
                            onPressed: () => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WelcomePage()),
                                (Route<dynamic> route) => false),
                            color: Colors.white,
                            child: Text(
                              'Вийти',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: width * 0.026),
                    Container(
                      height: height * 0.4,
                      width: width * 0.01,
                      color: Colors.blue,
                    ),
                    SizedBox(width: width * 0.026),
                    FutureBuilder(
                      future: _getData(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          _reader = snapshot.data;
                          return Text(
                            'ID: ${_reader[0]['id']}\n\n'
                            'email: \n${_reader[0]['email']}\n\n'
                            'name: \n${_reader[0]['name']}\n\n'
                            'Номер телефона: \n${_reader[0]['phone']}\n\n'
                            'Адреса: \n${_reader[0]['adress']}\n\n'
                            'Дата народження: \n${_reader[0]['data_narodzhennya']}',
                            style: TextStyle(fontSize: width * 0.045),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.03),
          Container(
            padding: EdgeInsets.only(
                top: height * 0.045,
                bottom: height * 0.025,
                left: width * 0.06),
            color: Theme.of(context).dividerColor,
            width: width * 0.91,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Мої книги:',
                    style: TextStyle(
                      fontSize: width * 0.07,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Container(
            width: width * 0.8,
            height: height * 0.46,
            child: FutureBuilder(
              future: _getBooks(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  _books = snapshot.data;
                  return Center(
                    child: ListView.builder(
                      itemCount: _books.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            SizedBox(height: height * 0.032),
                            Container(
                              width: width * 0.9,
                              height: height * 0.17,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context).dividerColor,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: width * 0.062),
                                  Container(
                                    child: Column(
                                      children: [
                                        SizedBox(height: height * 0.03),
                                        Text(
                                          '${_books[index]['id']}    ${_books[index]['nazva']}',
                                          style: TextStyle(
                                              fontSize: width * 0.05,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: height * 0.02),
                                        Container(
                                          width: width * 0.55,
                                          height: height * 0.002,
                                          color: Theme.of(context).hintColor,
                                        ),
                                        SizedBox(height: height * 0.014),
                                        Text(
                                          "${_books[index]['avtor']}              ${_books[index]['pages']}",
                                          style: TextStyle(
                                              fontSize: width * 0.034),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width * 0.019),
                                  VerticalDivider(
                                      color: Theme.of(context).hintColor),
                                  SizedBox(width: width * 0.019),
                                  Container(
                                    width: width * 0.18,
                                    height: width * 0.18,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.blueAccent,
                                    ),
                                    child: Icon(Icons.book, size: height * 0.06),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
