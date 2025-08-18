class ModelDropdown {
  String id;
  String text;

  ModelDropdown({this.id = "", this.text = ""});

  bool isEmpty() {
    return id.isEmpty && text.isEmpty;
  }

  @override
  String toString() {
    return "id: $id, nama: $text, ";
  }

  factory ModelDropdown.fromJson(Map<String, dynamic> json) {
    return ModelDropdown(
      id: json["id"],
      text: json["text"] ?? "",
    );
  }
}
