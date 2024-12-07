// lib/models/menu.dart
import 'dart:convert';

List<Menu> menuFromJson(String str) =>
    List<Menu>.from(json.decode(str).map((x) => Menu.fromJson(x)));

class Menu {
  final int id;
  final String name;

  Menu({
    required this.id,
    required this.name,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
