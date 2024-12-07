// lib/models/review.dart

import 'dart:convert';

List<Review> reviewFromJson(String str) =>
    List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
  final String id;
  final String menu;
  final String place;
  final int rating;
  final String description;

  Review({
    required this.id,
    required this.menu,
    required this.place,
    required this.rating,
    required this.description,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      menu: json['menu'],
      place: json['place'],
      rating: json['rating'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu': menu,
      'place': place,
      'rating': rating,
      'description': description,
    };
  }
}
