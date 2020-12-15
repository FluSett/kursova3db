import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FullScreenDialogs {
  showFullScreenLoadingDialog(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Color.fromRGBO(0, 0, 0, 0.5),
      transitionDuration: Duration(microseconds: 200),
      pageBuilder: (BuildContext context, Animation first, Animation second) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color.fromRGBO(0, 0, 0, 0.5),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    );
  }
}