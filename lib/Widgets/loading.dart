import 'package:flutter/material.dart';

showLoading(context) {
  AlertDialog alert = AlertDialog(
    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircularProgressIndicator(),
        SizedBox(
          width: 20,
        ),
        Text("Please Wait...")
      ],
    ),
  );

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
