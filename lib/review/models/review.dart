import 'dart:convert';

List<ReviewList> reviewListFromJson(dynamic data) =>
    List<ReviewList>.from(data.map((x) => ReviewList.fromJson(x)));

String reviewListToJson(List<ReviewList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewList {
  String model;
  String pk;
  Fields fields;

  ReviewList({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory ReviewList.fromJson(Map<String, dynamic> json) => ReviewList(
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
  //TODO: sementara aku ganti jadi integer
  int menu;
  String place;
  int rating;
  String description;
  String? _ownerReply;

  Fields({
    required this.user,
    required this.menu,
    required this.place,
    required this.rating,
    required this.description,
    String? ownerReply, // Parameter untuk nilai ownerReply
  }) : _ownerReply = ownerReply;

  // Getter untuk memberikan nilai default jika _ownerReply null
  String get ownerReply => _ownerReply ?? 'No reply yet';

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        menu: json["menu"],
        place: json["place"],
        rating: json["rating"],
        description: json["description"],
        ownerReply: json["owner_reply"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "menu": menu,
        "place": place,
        "rating": rating,
        "description": description,
        "owner_reply": _ownerReply,
      };
}
