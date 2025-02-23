import 'dart:convert';
import 'package:http/http.dart' as http;

class DontpadApi {
  static const String baseUrl = "https://api.dontpad.com";

  // Fetch note content
  static Future<String?> fetchNote(String roomName) async {
    final url = "$baseUrl/$roomName.body.json?lastModified=0";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['body'] ?? '';
      } else {
        print("Fetch Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Fetch Exception: $e");
      return null;
    }
  }
}
