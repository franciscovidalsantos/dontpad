import 'package:dontpad/src/dto/note_dto.dart';
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
  NoteDto? _note;

  @override
  void initState() {
    super.initState();
    _loadNote(); // we can fetch it later since we have out loading waiting
  }

  // Load note from dontpad API
  Future<void> _loadNote() async {
    var note = await DontpadApi.getNote(widget.roomName);

    setState(() {
      if (note != null) {
        _note = note;
        _controller.text = note.body;
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Failed to load note.")));
        }
      }
      _isLoading = false;
    });
  }

  // Save out note though POST
  Future<void> _saveNote() async {
    // we need to load in order to check lastModified
    // considering that my first fetch to display the
    // page might not be the same when the new note
    // is being displayed
    _loadNote();

    setState(() => _isLoading = true);

    final success = await DontpadApi.postNote(
      widget.roomName,
      _controller.text,
      _note!.lastModified,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Note saved successfully!' : 'Failed to save note.',
          ),
        ),
      );
    }

    // force to load our body values to update the
    // controller once again in case the note failed due to
    // someone making changes on our adress body while we
    // tried to apply ours
    if (success) {
      setState(() => _isLoading = true);
      _loadNote();
    }
  }

  void _refreshPage() async {
    setState(() => _isLoading = true);
    await _loadNote();
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
          IconButton(icon: Icon(Icons.save), onPressed: _saveNote),
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
