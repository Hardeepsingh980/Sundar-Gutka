import 'package:flutter/material.dart';

class HukamScreen extends StatelessWidget {

  final String hukam;

  const HukamScreen({Key key, this.hukam}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(hukam),
    );
  }
}