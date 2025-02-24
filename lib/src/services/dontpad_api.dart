import 'dart:convert';
import 'package:dontpad/src/dto/note_dto.dart';
import 'package:http/http.dart' as http;

class DontpadApi {
  static const String baseUrl = "https://api.dontpad.com";

  // Fetch note content
  static Future<NoteDto?> getNote(String roomName) async {
    final url = "$baseUrl/$roomName.body.json?lastModified=0";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return NoteDto.fromJson(data);
      } else {
        print("Fetch Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Fetch Exception: $e");
      return null;
    }
  }

  // Write note content
  static Future<bool> postNote(
    String roomName,
    String body,
    int lastModified,
  ) async {
    final url = "$baseUrl/$roomName";

    try {
      final payload = {"text": body, "lastModified": lastModified.toString()};
      final response = await http.post(Uri.parse(url), body: payload);

      if (response.statusCode == 200) {
        // TODO: remove lastModifiedValue
        var lastModifiedValue = int.tryParse(response.body.trim());
        if (lastModifiedValue != null) {
          print("Write successful. New lastModified: $lastModifiedValue");
          return true;
        } else {
          print("Failed to parse lastModified from response.");
          return false;
        }
      } else {
        print("Write Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Write Exception: $e");
      return false;
    }
  }
}
