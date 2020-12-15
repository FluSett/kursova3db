import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:kursova/pages/book/booklist.dart';
import 'package:kursova/pages/reader/reader_profile.dart';

class ReaderPage extends StatefulWidget {
  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _page = 0;

  Widget _currentPage = BookListPage();

  Widget _pageChooser() {
    switch (_page) {
      case 0:
        return BookListPage();
      case 1:
        return ReaderProfilePage();
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
      body: _currentPage,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: height * 0.062,
        items: <Widget>[
          Icon(
            Icons.dns,
            size: width * 0.07,
            color: _page != 0
                ? Theme.of(context).hintColor
                : Theme.of(context).accentColor,
          ),
          Icon(
            Icons.person,
            size: width * 0.07,
            color: _page != 1
                ? Theme.of(context).hintColor
                : Theme.of(context).accentColor,
          ),
        ],
        color: Theme.of(context).dividerColor,
        buttonBackgroundColor: Theme.of(context).dividerColor,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 500),
        onTap: (index) {
          setState(() {
            _page = index;
            _currentPage = _pageChooser();
          });
        },
      ),
    );
  }
}
