import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:kursova/pages/formular/formular_archive.dart';
import 'package:kursova/pages/librarian/add.dart';
import 'package:kursova/pages/librarian/librarian_profile.dart';
import 'package:kursova/pages/book/booklist.dart';

class LibrarianPage extends StatefulWidget {
  @override
  _LibrarianPageState createState() => _LibrarianPageState();
}

class _LibrarianPageState extends State<LibrarianPage> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _page = 0;

  Widget _currentPage = BookListPage();

  Widget _pageChooser() {
    switch (_page) {
      case 0:
        return BookListPage();
      case 1:
        return AddPage();
      case 2:
        return FormularArchivePage();
      case 3:
        return LibrarianProfilePage();
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
            Icons.create,
            size: width * 0.07,
            color: _page != 1
                ? Theme.of(context).hintColor
                : Theme.of(context).accentColor,
          ),
          Icon(
            Icons.find_in_page,
            size: width * 0.07,
            color: _page != 2
                ? Theme.of(context).hintColor
                : Theme.of(context).accentColor,
          ),
          Icon(
            Icons.person,
            size: width * 0.07,
            color: _page != 3
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
