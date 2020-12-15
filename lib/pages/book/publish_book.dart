import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:kursova/widgets/loading.dart';
import 'package:http/http.dart' as http;

class PublishBookPage extends StatefulWidget {
  final String bookID, bookNazva, bookAvtor, bookPages;

  PublishBookPage(
      {Key key,
      @required this.bookID,
      @required this.bookNazva,
      @required this.bookAvtor,
      @required this.bookPages})
      : super(key: key);

  @override
  _PublishBookPageState createState() => _PublishBookPageState();
}

class _PublishBookPageState extends State<PublishBookPage> {
  var localBox = Hive.box('local');

  DateTime _dateNow = DateTime.now();

  String id;

  TextEditingController _readerController = TextEditingController();

  void _takeBook() async {
    FocusScope.of(context).requestFocus(FocusNode());

    FullScreenDialogs().showFullScreenLoadingDialog(context);

    setState(() {
      id = localBox.get('id') ?? '2';
    });

    var url = "https://dbserverproject.000webhostapp.com/formular/write.php";
    var data = {
      "librarian_id": id,
      "reader_id": _readerController.text,
      "book_nazva": widget.bookNazva,
      "data_vudachi": "${_dateNow.year}-${_dateNow.month}-${_dateNow.day}"
    };

    var res = await http.post(url, body: data);

    Navigator.of(context).pop();
    switch (jsonDecode(res.body)) {
      case 'true':
        return showSnackBar('Успіх: Книга видана');
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
            SizedBox(height: height * 0.05),
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
