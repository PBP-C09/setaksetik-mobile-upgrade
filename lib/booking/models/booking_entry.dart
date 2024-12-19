import 'dart:convert';

List<BookingEntry> bookingEntryFromJson(String str) => List<BookingEntry>.from(json.decode(str).map((x) => BookingEntry.fromJson(x)));

String bookingEntryToJson(List<BookingEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookingEntry {
    String model;
    int pk;
    Fields fields;

    BookingEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory BookingEntry.fromJson(Map<String, dynamic> json) => BookingEntry(
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
    int menuItems;
    DateTime bookingDate;
    int numberOfPeople;
    String status;

    Fields({
        required this.user,
        required this.menuItems,
        required this.bookingDate,
        required this.numberOfPeople,
        required this.status,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        menuItems: json["menu_items"],
        bookingDate: DateTime.parse(json["booking_date"]),
        numberOfPeople: json["number_of_people"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "menu_items": menuItems,
        "booking_date": bookingDate.toIso8601String(),
        "number_of_people": numberOfPeople,
        "status": status,
    };
}
