class TodoDM {
  late String id;
  late String title;
  late String description;
  late DateTime date;
  late bool isDone;

  TodoDM({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
  });

  TodoDM.fromJson(Map json) {
    id = json["id"];
    title = json["title"];
    description = json["description"];
    date = DateTime.fromMillisecondsSinceEpoch(json["date"]);
    isDone = json["isDone"] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date.millisecondsSinceEpoch,
      "isDone": isDone,
    };
  }
}
