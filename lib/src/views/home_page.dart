import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'dontpad',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            // shadows: [
            //   Shadow(color: Colors.black, offset: Offset.fromDirection(1, 1.5))
            // ],
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(children: []),
    );
  }
}
