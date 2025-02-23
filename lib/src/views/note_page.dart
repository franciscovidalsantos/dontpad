import 'package:dontpad/src/services/dontpad_api.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchNote(); // we can fetch it later since we have out loading waiting
  }

  // Fetch note from dontpad API
  Future<void> _fetchNote() async {
    var noteContent = await DontpadApi.fetchNote(widget.roomName);

    setState(() {
      _controller.text = noteContent ?? "Failed to load note.";
      _isLoading = false;
    });
  }

  void _refreshPage() async {
    setState(() {
      _isLoading = true;
    });

    await _fetchNote();
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
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _refreshPage),
        ],
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
