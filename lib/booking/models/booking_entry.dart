import 'dart:convert';

List<BookingEntry> bookingEntryFromJson(String str) => List<BookingEntry>.from(json.decode(str).map((x) => BookingEntry.fromJson(x)));

String bookingEntryToJson(List<BookingEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookingEntry {
    int id;
    String user;
    String menu;
    DateTime bookingDate;
    int numberOfPeople;
    String status;

    BookingEntry({
        required this.id,
        required this.user,
        required this.menu,
        required this.bookingDate,
        required this.numberOfPeople,
        required this.status,
    });

    factory BookingEntry.fromJson(Map<String, dynamic> json) => BookingEntry(
        id: json["id"],
        user: json["user"],
        menu: json["menu"],
        bookingDate: DateTime.parse(json["booking_date"]),
        numberOfPeople: json["number_of_people"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "menu": menu,
        "booking_date": bookingDate.toIso8601String(),
        "number_of_people": numberOfPeople,
        "status": status,
    };
}