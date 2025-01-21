import 'dart:convert';

class MessageEntry {
  String model;
  String pk;
  Fields fields;

  MessageEntry({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory MessageEntry.fromJson(Map<String, dynamic> json) => MessageEntry(
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
  int sender;
  int receiver;
  String content;
  DateTime timestamp;

  Fields({
    required this.sender,
    required this.receiver,
    required this.content,
    required this.timestamp,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        sender: json["sender"],
        receiver: json["receiver"],
        content: json["content"],
        timestamp: DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "sender": sender,
        "receiver": receiver,
        "content": content,
        "timestamp":
            "${timestamp.year.toString().padLeft(4, '0')}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}",
      };
}

// To parse this JSON data, do
//
//     final messageEntry = messageEntryFromJson(jsonString);

List<MessageEntry> messageEntryFromJson(String str) => List<MessageEntry>.from(
    json.decode(str).map((x) => MessageEntry.fromJson(x))
);

String messageEntryToJson(List<MessageEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));