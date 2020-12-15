import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kursova/pages/book/take_book.dart';

class BookListReaderPage extends StatefulWidget {
  @override
  _BookListReaderPageState createState() => _BookListReaderPageState();
}

class _BookListReaderPageState extends State<BookListReaderPage> {
  List _dataBooks = [];

  void initState() {
    super.initState();
    getBooks();
  }

  void getBooks() async {
    var url = "https://dbserverproject.000webhostapp.com/book/get_info.php";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _dataBooks = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Список книг"),
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _dataBooks.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                SizedBox(height: height * 0.032),
                Container(
                  width: width * 0.9,
                  height: height * 0.17,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).dividerColor,
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: width * 0.062),
                      Container(
                        child: Column(
                          children: [
                            SizedBox(height: height * 0.03),
                            Text(
                              '${_dataBooks[index]['id']}    ${_dataBooks[index]['nazva']}',
                              style: TextStyle(
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: height * 0.02),
                            Container(
                              width: width * 0.55,
                              height: height * 0.002,
                              color: Theme.of(context).hintColor,
                            ),
                            SizedBox(height: height * 0.014),
                            Text(
                              "${_dataBooks[index]['avtor']}              ${_dataBooks[index]['pages']}",
                              style: TextStyle(fontSize: width * 0.034),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width * 0.019),
                      VerticalDivider(color: Theme.of(context).hintColor),
                      SizedBox(width: width * 0.019),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TakeBookPage(bookID: '${_dataBooks[index]['id']}', bookNazva: '${_dataBooks[index]['nazva']}', bookAvtor: '${_dataBooks[index]['avtor']}', bookPages: '${_dataBooks[index]['pages']}',)),
                        ),
                        child: Container(
                          width: width * 0.18,
                          height: width * 0.18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blueAccent,
                          ),
                          child: Icon(Icons.add, size: height * 0.06),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
