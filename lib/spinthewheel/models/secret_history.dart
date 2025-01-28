import 'dart:convert';

List<SecretHistory> secretHistoryFromJson(String str) => List<SecretHistory>.from(json.decode(str).map((x) => SecretHistory.fromJson(x)));

String secretHistoryToJson(List<SecretHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SecretHistory {
    String model;
    String pk;
    Fields fields;

    SecretHistory({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory SecretHistory.fromJson(Map<String, dynamic> json) => SecretHistory(
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
    String winner;
    DateTime spinTime;
    String note;

    Fields({
        required this.user,
        required this.winner,
        required this.spinTime,
        required this.note,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        winner: json["winner"],
        spinTime: DateTime.parse(json["spin_time"]),
        note: json["note"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "winner": winner,
        "spin_time": "${spinTime.year.toString().padLeft(4, '0')}-${spinTime.month.toString().padLeft(2, '0')}-${spinTime.day.toString().padLeft(2, '0')}",
        "note": note,
    };
}
