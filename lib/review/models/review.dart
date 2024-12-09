import 'dart:convert';

// Function to parse the JSON string into a list of ReviewList objects
List<ReviewList> reviewListFromJson(String str) {
  final data = json.decode(str);
  return List<ReviewList>.from(data.map((item) => ReviewList.fromJson(item)));
}

class ReviewList {
  final String id;
  final ReviewFields fields;

  ReviewList({
    required this.id,
    required this.fields,  // fields is of type ReviewFields
  });

  // Factory constructor to create a ReviewList object from JSON
  factory ReviewList.fromJson(Map<String, dynamic> json) {
    return ReviewList(
      id: json['id'],
      fields: ReviewFields.fromJson(json['fields']),  // Parse 'fields' into ReviewFields
    );
  }
}

// Model for the nested fields in the ReviewList
class ReviewFields {
  final String menu;
  final String place;
  final int rating;
  final String description;
  final String? ownerReply;

  ReviewFields({
    required this.menu,
    required this.place,
    required this.rating,
    required this.description,
    this.ownerReply,
  });

  // Factory constructor to create a ReviewFields object from JSON
  factory ReviewFields.fromJson(Map<String, dynamic> json) {
    return ReviewFields(
      menu: json['menu'],
      place: json['place'],
      rating: json['rating'],
      description: json['description'],
      ownerReply: json['owner_reply'],
    );
  }
}
