import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kursova/pages/formular/formular_search.dart';

class FormularArchivePage extends StatefulWidget {
  @override
  _FormularArchivePageState createState() => _FormularArchivePageState();
}

class _FormularArchivePageState extends State<FormularArchivePage> {
  List _dataFormulars = [];

  TextEditingController _searchController = TextEditingController();

  void initState() {
    super.initState();
    getFormulars();
  }

  void getFormulars() async {
    var url = "https://dbserverproject.000webhostapp.com/formular/get_info.php";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _dataFormulars = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Архів"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormularSearchPage()),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _dataFormulars.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                SizedBox(height: height * 0.032),
                Container(
                  width: width * 0.9,
                  height: height * 0.18,
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
                            Row(
                              children: [
                                Text(
                                  '${_dataFormulars[index]['id']}       Читач: ${_dataFormulars[index]['reader']}',
                                  style: TextStyle(
                                      fontSize: width * 0.05,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: width * 0.03),
                              ],
                            ),
                            SizedBox(height: height * 0.02),
                            Container(
                              width: width * 0.55,
                              height: height * 0.002,
                              color: Theme.of(context).hintColor,
                            ),
                            SizedBox(height: height * 0.014),
                            Text(
                              'Книга: ${_dataFormulars[index]['book']}\n\n'
                              'Бібіліотекар: ${_dataFormulars[index]['librarian']}',
                              style: TextStyle(fontSize: width * 0.034),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width * 0.019),
                      VerticalDivider(color: Theme.of(context).hintColor),
                      SizedBox(width: width * 0.019),
                      Container(
                        width: width * 0.18,
                        height: width * 0.18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blueAccent,
                        ),
                        child: Icon(Icons.edit, size: height * 0.06),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
