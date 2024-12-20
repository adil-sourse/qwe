import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.black,
          middle: Text(
            'Настройки',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          ),
        ),
        child: SafeArea(
            child: Column(
          children: [],
        )));
  }
}
