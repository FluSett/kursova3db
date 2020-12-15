import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kursova/widgets/loading.dart';

class FormularSearchPage extends StatefulWidget {
  @override
  _FormularSearchPageState createState() => _FormularSearchPageState();
}

class _FormularSearchPageState extends State<FormularSearchPage> {
  List _dataFormulars = [];

  TextEditingController _searchController = TextEditingController();

  void initState() {
    super.initState();
  }

  void _searchFormulars() async {
    var url = "https://dbserverproject.000webhostapp.com/formular/search_formular.php";
    var data = {
      "id": _searchController.text,
    };
    var response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      setState(() {
        _dataFormulars = json.decode(response.body);
      });
    }
  }

  void _removeFormular(String value) async {
    FocusScope.of(context).requestFocus(FocusNode());

    FullScreenDialogs().showFullScreenLoadingDialog(context);

    var url = "https://dbserverproject.000webhostapp.com/formular/remove.php";
    var data = {
      "id": '$value',
    };

    var res = await http.post(url, body: data);

    Navigator.of(context).pop();
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
      ),
      body: Column(
          children: [
            SizedBox(height: height * 0.04),
            Container(
              width: width * 0.83,
              height: height * 0.07,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).dividerColor,
              ),
              child: Row(
                children: [
                  SizedBox(width: width * 0.082),
                  Container(
                    width: width * 0.55,
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Пошук формуляра по номеру id',
                      ),
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontStyle: FontStyle.italic,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(width: width * 0.06),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightBlueAccent),
                    child: IconButton(
                      onPressed: _searchFormulars,
                      icon: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Theme.of(context).hintColor, height: height * 0.066),
            Padding(
              padding: EdgeInsets.only(right: width * 0.38),
              child: Text(
              'Результат пошуку:',
              style: TextStyle(fontSize: width * 0.06, fontWeight: FontWeight.bold),
            ),),
            Expanded(
              child: ListView.builder(
                itemCount: _dataFormulars.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      SizedBox(height: height * 0.032),
                      Container(
                        width: width * 0.9,
                        height: height * 0.20,
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
                            GestureDetector(
                        onTap: () => _removeFormular('${_dataFormulars[index]['id']}'),
                        child: Container(
                          width: width * 0.18,
                          height: width * 0.18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blueAccent,
                          ),
                          child: Icon(Icons.delete, size: height * 0.06),
                        ),
                      ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
      ),
    );
  }
}
