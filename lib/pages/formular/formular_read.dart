import 'package:flutter/material.dart';

class FormularReadPage extends StatefulWidget {
  @override
  _FormularReadPageState createState() => _FormularReadPageState();
}

class _FormularReadPageState extends State<FormularReadPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
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
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
