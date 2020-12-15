import 'package:flutter/material.dart';
import 'package:kursova/pages/formular/formular_write.dart';
import 'package:kursova/pages/librarian/add_book.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  int _page = 0;
  Widget _currentPage = AddBookPage();

  void pageSelect(int value) {
    setState(() {
      _page = value;
      _currentPage = _pageChooser();
    });
  }

  Widget _pageChooser() {
    switch (_page) {
      case 0:
        return AddBookPage();
      case 1:
        return FormularWritePage();
      default:
        return Container(
          child: Text('No page found!'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.3757),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: height * 0.16),
              Container(
                padding: EdgeInsets.only(
                    top: height * 0.045,
                    bottom: height * 0.045,
                    left: width * 0.06),
                width: width * 0.90,
                color: Theme.of(context).dividerColor,
                child: Column(
                  children: [
                    Text(
                      'Добавити',
                      style: TextStyle(
                        fontSize: width * 0.075,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                    Container(
                      child: Row(
                        children: [
                          SizedBox(width: width * 0.11),
                          GestureDetector(
                            onTap: () {
                              pageSelect(0);
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Text(
                                    'Книга',
                                    style: TextStyle(
                                      fontSize: height * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: _page == 0
                                          ? Colors.red
                                          : Theme.of(context).hintColor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Container(
                                    height: height * 0.01,
                                    child: CircleAvatar(
                                      backgroundColor: _page == 0
                                          ? Colors.red
                                          : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.12),
                          GestureDetector(
                            onTap: () {
                              pageSelect(1);
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Text(
                                    'Формуляр',
                                    style: TextStyle(
                                      fontSize: height * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: _page == 1
                                          ? Colors.red
                                          : Theme.of(context).hintColor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Container(
                                    height: height * 0.01,
                                    child: CircleAvatar(
                                      backgroundColor: _page == 1
                                          ? Colors.red
                                          : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: _currentPage,
    );
  }
}
