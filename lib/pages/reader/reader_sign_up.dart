import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:kursova/pages/reader/reader.dart';
import 'package:kursova/widgets/loading.dart';

class ReaderSignUpPage extends StatefulWidget {
  @override
  _ReaderSignUpPageState createState() => _ReaderSignUpPageState();
}

class _ReaderSignUpPageState extends State<ReaderSignUpPage> {
  var localBox = Hive.box('local');

  DateTime _dateStart = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _adressController = TextEditingController();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
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

    var url =
        "https://dbserverproject.000webhostapp.com/reader/auth/reader_sign_up.php";
    var data = {
      "email": _emailController.text,
      "password": _passwordController.text,
      "name":  _nameController.text,
      "phone": _phoneController.text,
      "adress": _adressController.text,
      "data_narodzhennya": "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}",
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
        localBox.put('role', 'reader');

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ReaderPage()),
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
        "https://dbserverproject.000webhostapp.com/reader/get_my_id.php";
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
                    'images/reader.png',
                    scale: width * 0.0062,
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    'Читач',
                    style: TextStyle(fontSize: width * 0.045),
                  ),
                ],
              ),
            ),
            //SizedBox(height: height * 0.02),
            Container(
              width: width * 0.7,
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(hintText: 'Електронна пошта'),
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),
            //SizedBox(height: height * 0.01),
            Container(
              width: width * 0.7,
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: 'Пароль'),
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),
           // SizedBox(height: height * 0.01),
            Row(
              children: [
                SizedBox(width: width * 0.15),
                Container(
                  width: width * 0.34,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Ім\'я'),
                    style: TextStyle(fontSize: width * 0.04),
                  ),
                ),
                SizedBox(
                  width: width * 0.042,
                ),
                RaisedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    'Дата народження: \n${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: width * 0.035),
                  ),
                  color: Colors.greenAccent,
                ),
              ],
            ),
           // SizedBox(height: height * 0.01),
            Container(
              width: width * 0.7,
              child: TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(hintText: 'Номер телефона'),
                style: TextStyle(fontSize: width * 0.04),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            //SizedBox(height: height * 0.01),
            Container(
              width: width * 0.7,
              child: TextFormField(
                controller: _adressController,
                decoration: InputDecoration(hintText: 'Адрес'),
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),
            SizedBox(height: height * 0.01),
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
            SizedBox(height: height * 0.03),
            InkWell(
              onTap: signUp,
              child: Container(
                width: width * 0.67,
                height: height * 0.08,
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
