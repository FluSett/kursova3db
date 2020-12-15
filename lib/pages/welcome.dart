import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kursova/pages/librarian/librarian.dart';
import 'package:kursova/pages/librarian/librarian_sign_in.dart';
import 'package:kursova/pages/reader/reader.dart';
import 'package:kursova/pages/reader/reader_sign_in.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var localBox = Hive.box('local');

  String _powered = 'Курсова', email = 'none', role = 'none';
  bool _isKursovaEnabled = false;

  void kursovaButton() {
    if (_isKursovaEnabled == false) {
      setState(() {
        _powered = 'Ващенюк Арсен';
      });
      _isKursovaEnabled = true;
    } else {
      setState(() {
        _powered = 'Курсова';
      });
      _isKursovaEnabled = false;
    }
  }

  void initState() {
    super.initState();
    setState(() {
      email = localBox.get('email') ?? '-';
      role = localBox.get('role') ?? '-';
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: height * 0.1),
          Text(
            'Оберіть, щоб продовжити:',
            style: TextStyle(
              fontSize: width * 0.065,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: height * 0.12),
          Row(
            children: [
              SizedBox(width: width * 0.066),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LibrarianSignInPage()),
                ),
                child: Container(
                  child: Column(
                    children: [
                      Image.asset(
                        'images/librarian.png',
                        scale: width * 0.014,
                      ),
                      SizedBox(height: height * 0.03),
                      Text(
                        'Бібліотекар',
                        style: TextStyle(fontSize: width * 0.055),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: width * 0.11),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReaderSignInPage()),
                ),
                child: Container(
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
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.17),
          OutlineButton(
            onPressed: () {
              if (role == '-') {
                return null;
              } else {
                switch (role) {
                  case 'librarian':
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibrarianPage()),
                        (Route<dynamic> route) => false);
                    break;
                  case 'reader':
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReaderPage()),
                        (Route<dynamic> route) => false);
                    break;
                }
              }
            },
            child: Text(
              email == '-'
                  ? 'Війдіть/зареєструйтесь, щоб повернутись в акаунт'
                  : 'Повернутись: \n$role \n$email',
              style: TextStyle(
                fontSize: width * 0.044,
              ),
            ),
          ),
          SizedBox(height: height * 0.06),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.blue,
              width: double.infinity,
              height: height * 0.01,
            ),
          ),
          SizedBox(height: height * 0.023),
          GestureDetector(
            onTap: kursovaButton,
            child: Container(
              child: Column(
                children: [
                  Text(
                    _powered,
                    style: TextStyle(
                      fontSize: width * 0.05,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Container(
                    color: Colors.blue,
                    width: width * 0.25,
                    height: height * 0.004,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
