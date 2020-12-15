import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:kursova/widgets/loading.dart';

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  TextEditingController _nazvaController = TextEditingController();
  TextEditingController _avtorController = TextEditingController();
  TextEditingController _pagesController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _addBook() async {
    FocusScope.of(context).requestFocus(FocusNode());

    FullScreenDialogs().showFullScreenLoadingDialog(context);

    var url = "https://dbserverproject.000webhostapp.com/book/add_book.php";
    var data = {
      "nazva": _nazvaController.text,
      "avtor": _avtorController.text,
      "pages": _pagesController.text,
    };

    var res = await http.post(url, body: data);

    Navigator.of(context).pop();
    switch (jsonDecode(res.body)) {
      case 'true':
        return showSnackBar('Успіх: Книга успішно добавлена');
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
                      controller: _nazvaController,
                      decoration: InputDecoration(hintText: 'Назва книги'),
                      style: TextStyle(fontSize: width * 0.04),
                    ),
                  ),
                  SizedBox(height: height * 0.037),
                  Container(
                    width: width * 0.7,
                    child: TextFormField(
                      controller: _avtorController,
                      decoration: InputDecoration(hintText: 'Автор книги'),
                      style: TextStyle(fontSize: width * 0.04),
                    ),
                  ),
                  SizedBox(height: height * 0.037),
                  Container(
                    width: width * 0.7,
                    child: TextFormField(
                      controller: _pagesController,
                      decoration:
                          InputDecoration(hintText: 'Кількість сторінок'),
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
                        'Добавити книгу',
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
