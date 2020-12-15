import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:kursova/pages/librarian/librarian.dart';
import 'package:kursova/widgets/loading.dart';

class LibrarianSignUpPage extends StatefulWidget {
  @override
  _LibrarianSignUpPageState createState() => _LibrarianSignUpPageState();
}

class _LibrarianSignUpPageState extends State<LibrarianSignUpPage> {
  var localBox = Hive.box('local');

  DateTime _dateStart = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _selectDate(BuildContext context) async {
    final DateTime picked = await  showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: _dateStart,
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  void signUp() async {
    FocusScope.of(context).requestFocus(FocusNode());

    FullScreenDialogs().showFullScreenLoadingDialog(context);

    var url = "https://dbserverproject.000webhostapp.com/librarian/auth/librarian_sign_up.php";
    var data = {
      "email": _emailController.text,
      "password": _passwordController.text,
      "name": _nameController.text,
      "data_narodzhennya":
          "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}",
      "data_start": "${_dateStart.year}-${_dateStart.month}-${_dateStart.day}",
    };

    var res = await http.post(url, body: data);

    Navigator.of(context).pop();
    
    switch (jsonDecode(res.body)) {
      case 'email-already-exists':
        return showSnackBar('Помилка: Пошта уже зареєстрована');
      case 'true':
        _getID();

        localBox.put('email', _emailController.text);
        localBox.put('password', _passwordController.text);
        localBox.put('role', 'librarian');

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LibrarianPage()),
            (Route<dynamic> route) => false);
        break;
      case 'false':
        return showSnackBar('Помилка: Сталася помилка доступу');
      default:
        return showSnackBar(jsonDecode(res.body));
    }
  }

  void _getID() async {
    var url =
        "https://dbserverproject.000webhostapp.com/librarian/get_my_id.php";
    var data = {
      "email": _emailController.text,
    };
    var response = await http.post(url, body: data);

    localBox.put('id', json.decode(response.body)[0]['id']);
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
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Реєстрація'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: height * 0.04),
            Container(
              child: Column(
                children: [
                  Image.asset(
                    'images/librarian.png',
                    scale: width * 0.016,
                  ),
                  SizedBox(height: height * 0.03),
                  Text(
                    'Бібліотекар',
                    style: TextStyle(fontSize: width * 0.055),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
            Container(
              width: width * 0.7,
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(hintText: 'Електронна пошта'),
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),
            SizedBox(height: height * 0.017),
            Container(
              width: width * 0.7,
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: 'Пароль'),
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),
            SizedBox(height: height * 0.017),
            Container(
              width: width * 0.7,
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Ім\'я'),
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),
            SizedBox(height: height * 0.017),
            Row(
              children: [
                SizedBox(width: width * 0.15),
                Text(
                  'Укажіть дату народження:',
                  style: TextStyle(
                    fontSize: width * 0.04,
                  ),
                ),
                SizedBox(width: width * 0.05),
                RaisedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.greenAccent,
                ),
              ],
            ),
            SizedBox(height: height * 0.04),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SizedBox(
                  height: height * 0.03,
                  width: width * 0.75,
                  child: Text(
                    'Уже маєте аккаунт? Авторизуватись',
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.04),
            InkWell(
              onTap: signUp,
              child: Container(
                width: width * 0.67,
                height: height * 0.09,
                padding: EdgeInsets.symmetric(vertical: 13),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Theme.of(context).accentColor,
                          offset: Offset(2, 4),
                          blurRadius: 8,
                          spreadRadius: 2)
                    ],
                    color: Colors.white),
                child: Text(
                  'Зареєструватись',
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
