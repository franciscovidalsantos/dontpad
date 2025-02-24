class NoteDto {
  final int lastModified;
  final String body;

  NoteDto({required this.lastModified, required this.body});

  // Factory constructor to create NoteDto from JSON
  factory NoteDto.fromJson(Map<String, dynamic> json) {
    return NoteDto(
      lastModified: json["lastModified"] ?? 0,
      body: json["body"] ?? "",
    );
  }

  // Method to convert NoteDto to JSON
  Map<String, dynamic> toJson() {
    return {"lastModified": lastModified, "body": body};
  }
}
