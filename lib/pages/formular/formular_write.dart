import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:kursova/widgets/loading.dart';

class FormularWritePage extends StatefulWidget {
  @override
  _FormularWritePageState createState() => _FormularWritePageState();
}

class _FormularWritePageState extends State<FormularWritePage> {
  DateTime _dateNow = DateTime.now();

  TextEditingController _bibliotekarController = TextEditingController();
  TextEditingController _readerController = TextEditingController();
  TextEditingController _bookController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _addBook() async {
    FocusScope.of(context).requestFocus(FocusNode());

    FullScreenDialogs().showFullScreenLoadingDialog(context);

    var url = "https://dbserverproject.000webhostapp.com/formular/add_formular.php";
    var data = {
      "bibliotekar": _bibliotekarController.text,
      "reader": _readerController.text,
      "book": _bookController.text,
      "data_vudachi": "${_dateNow.year}-${_dateNow.month}-${_dateNow.day}"
    };

    var res = await http.post(url, body: data);

    Navigator.of(context).pop();
    switch (jsonDecode(res.body)) {
      case 'true':
        return showSnackBar('Успіх: Формуляр успішно заповнений');
      case 'false':
        return showSnackBar('Помилка: Сталася помилка доступу');
      default:
        return showSnackBar(jsonDecode(res.body));
    }
  }

  void showSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
        backgroundColor: Theme.of(context).accentColor,
        behavior: SnackBarBehavior.floating,
        elevation: 6.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: height * 0.045,
                bottom: height * 0.045,
                left: width * 0.02,
              ),
              width: width * 0.90,
              color: Theme.of(context).dividerColor,
              child: Column(
                children: [
                  Container(
                    width: width * 0.7,
                    child: TextFormField(
                      controller: _bibliotekarController,
                      decoration: InputDecoration(hintText: 'Ваш id'),
                      style: TextStyle(fontSize: width * 0.04),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.037),
                  Container(
                    width: width * 0.7,
                    child: TextFormField(
                      controller: _readerController,
                      decoration: InputDecoration(hintText: 'id-Читача'),
                      style: TextStyle(fontSize: width * 0.04),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.037),
                  Container(
                    width: width * 0.7,
                    child: TextFormField(
                      controller: _bookController,
                      decoration: InputDecoration(hintText: 'id-Книги'),
                      style: TextStyle(fontSize: width * 0.04),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.07),
                  Align(
                    alignment: Alignment.topCenter,
                    child: RaisedButton(
                      onPressed: _addBook,
                      color: Colors.lightBlueAccent,
                      child: Text(
                        'Заповнити формуляр',
                        style: TextStyle(
                          fontSize: width * 0.04,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
