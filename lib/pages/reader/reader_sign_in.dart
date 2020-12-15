import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:kursova/pages/reader/reader.dart';
import 'package:kursova/pages/reader/reader_sign_up.dart';
import 'package:kursova/widgets/loading.dart';

class ReaderSignInPage extends StatefulWidget {
  @override
  _ReaderSignInPageState createState() => _ReaderSignInPageState();
}

class _ReaderSignInPageState extends State<ReaderSignInPage> {
  var localBox = Hive.box('local');
  
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void signIn() async {
    FocusScope.of(context).requestFocus(FocusNode());

    FullScreenDialogs().showFullScreenLoadingDialog(context);

    var url = "https://dbserverproject.000webhostapp.com/reader/auth/reader_sign_in.php";
    var data = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    var res = await http.post(url, body: data);

    Navigator.of(context).pop();
    switch (jsonDecode(res.body)) {
      case 'password-matched':
        _getID();

        localBox.put('email', _emailController.text);
        localBox.put('password', _passwordController.text);
        localBox.put('role', 'reader');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ReaderPage()),
          (Route<dynamic> route) => false);
        break;
      case 'wrong-password':
        return showSnackBar('Помилка: Неправильний пароль');
      case 'missing-email':
        return showSnackBar('Помилка: пошта не зареєстрована');
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
        title: Text('Авторизація'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: height * 0.12),
            Container(
              child: Column(
                children: [
                  Image.asset(
                    'images/reader.png',
                    scale: width * 0.00222,
                  ),
                  SizedBox(height: height * 0.03),
                  Text(
                    'Читач',
                    style: TextStyle(fontSize: width * 0.055),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.12),
            Container(
              width: width * 0.7,
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(hintText: 'Електронна пошта'),
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),
            SizedBox(height: height * 0.037),
            Container(
              width: width * 0.7,
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: 'Пароль'),
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),
            SizedBox(height: height * 0.06),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReaderSignUpPage()),
                  );
                },
                child: SizedBox(
                  height: height * 0.03,
                  width: width * 0.75,
                  child: Text(
                    'Ще не зареєстровані? Зареєструватись',
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
              onTap: signIn,
              child: Container(
                width: width * 0.87,
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
                  'Авторизуватись',
                  style: TextStyle(
                    fontSize: width * 0.06,
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
