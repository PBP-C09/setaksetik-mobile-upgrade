// To parse this JSON data, do
//
//     final spinHistory = spinHistoryFromJson(jsonString);

import 'dart:convert';

List<SpinHistory> spinHistoryFromJson(String str) => List<SpinHistory>.from(json.decode(str).map((x) => SpinHistory.fromJson(x)));

String spinHistoryToJson(List<SpinHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpinHistory {
    Model model;
    String pk;
    Fields fields;

    SpinHistory({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory SpinHistory.fromJson(Map<String, dynamic> json) => SpinHistory(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String winner;
    int winnerId;
    DateTime spinTime;
    String note;

    Fields({
        required this.user,
        required this.winner,
        required this.winnerId,
        required this.spinTime,
        required this.note,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        winner: json["winner"],
        winnerId: json["winnerId"],
        spinTime: DateTime.parse(json["spin_time"]),
        note: json["note"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "winner": winner,
        "winnerId": winnerId,
        "spin_time": "${spinTime.year.toString().padLeft(4, '0')}-${spinTime.month.toString().padLeft(2, '0')}-${spinTime.day.toString().padLeft(2, '0')}",
        "note": note,
    };
}

enum Model {
    SPINTHEWHEEL_SPINHISTORY
}

final modelValues = EnumValues({
    "spinthewheel.spinhistory": Model.SPINTHEWHEEL_SPINHISTORY
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
