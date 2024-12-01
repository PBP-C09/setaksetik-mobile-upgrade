import 'dart:convert';

List<Review> reviewFromJson(String str) =>
    List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
  String model;
  int pk;
  Fields fields;

  Review({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int user;
  String name;
  String description;
  DateTime dateAdded;

  Fields({
    required this.user,
    required this.name,
    required this.description,
    required this.dateAdded,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        name: json["name"],
        description: json["description"],
        dateAdded: DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "name": name,
        "description": description,
        "date_added":
            "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
      };
}