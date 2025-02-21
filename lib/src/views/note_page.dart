import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotePage extends StatefulWidget {
  const NotePage({required this.roomName, super.key});
  final String roomName;

  @override
  State<NotePage> createState() {
    return _NotePageState();
  }
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = true;
  // String? _errorMessage;

  @override
  void initState() {
    _fetchNote();
    super.initState();
  }

  // Fetch note from dontpad API
  Future<void> _fetchNote() async {
    final url =
        "https://api.dontpad.com/${widget.roomName}.body.json?lastModified=0"; // dont want to harcode the token
    print("Fetching from: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _controller.text = data['body'] ?? '';
          _isLoading = false;
        });
      } else {
        print("Error: Received unexpected response.");
        setState(() {
          // _errorMessage =
          //     "Error: Received unexpected response (Status Code: ${response.statusCode})";
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching note: $e");
      setState(() {
        // _errorMessage = "Error fetching note: $e";
        _isLoading = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        title: Text(
          "/${widget.roomName}",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
