import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kursova/widgets/loading.dart';
import 'package:http/http.dart' as http;

class TakeBookPage extends StatefulWidget {
  final String bookID, bookNazva, bookAvtor, bookPages;

  TakeBookPage(
      {Key key,
      @required this.bookID,
      @required this.bookNazva,
      @required this.bookAvtor,
      @required this.bookPages})
      : super(key: key);

  @override
  _TakeBookPageState createState() => _TakeBookPageState();
}

class _TakeBookPageState extends State<TakeBookPage> {
  var localBox = Hive.box('local');
  
  DateTime _dateNow = DateTime.now();

  String id;

  void _takeBook() async {
    FocusScope.of(context).requestFocus(FocusNode());

    FullScreenDialogs().showFullScreenLoadingDialog(context);

    setState(() {
      id = localBox.get('id') ?? '2';
    });

    var url = "https://dbserverproject.000webhostapp.com/formular/write.php";
    var data = {
      "librarian_id": '1',
      "reader_id": id,
      "book_nazva": widget.bookNazva,
      "data_vudachi": "${_dateNow.year}-${_dateNow.month}-${_dateNow.day}"
    };

    var res = await http.post(url, body: data);

    Navigator.of(context).pop();
    switch (jsonDecode(res.body)) {
      case 'true':
        return showSnackBar('Успіх: Книга отримана');
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
      appBar: AppBar(
        title: Text('Книга'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: height * 0.13),
            Text('ID - ${widget.bookID}'),
            SizedBox(height: height * 0.03),
            Text('Назва - ${widget.bookNazva}'),
            SizedBox(height: height * 0.03),
            Text('Автор - ${widget.bookAvtor}'),
            SizedBox(height: height * 0.03),
            Text('Кількість сторінок - ${widget.bookPages}'),
            SizedBox(height: height * 0.06),
            RaisedButton(
              onPressed: _takeBook,
              child: Text('Взяти книгу'),
            ),
          ],
        ),
      ),
    );
  }
}
