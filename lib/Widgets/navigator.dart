import 'package:flutter/material.dart';

navigatorRemove(BuildContext context, Widget page) {
  return Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (_) => page), (route) => false);
}
