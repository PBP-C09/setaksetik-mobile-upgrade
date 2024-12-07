// To parse this JSON data, do
//
//     final menuList = menuListFromJson(jsonString);

import 'dart:convert';

List<MenuList> menuListFromJson(String str) => List<MenuList>.from(json.decode(str).map((x) => MenuList.fromJson(x)));

String menuListToJson(List<MenuList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MenuList {
    int pk;
    Model model;
    Fields fields;

    MenuList({
        required this.pk,
        required this.model,
        required this.fields,
    });

    factory MenuList.fromJson(Map<String, dynamic> json) => MenuList(
        pk: json["pk"],
        model: modelValues.map[json["model"]]!,
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "model": modelValues.reverse[model],
        "fields": fields.toJson(),
    };
}

class Fields {
    // int id;
    String menu;
    String category;
    String restaurantName;
    String image;
    City city;
    int price;
    double rating;
    String specialized;
    bool takeaway;
    bool delivery;
    bool outdoor;
    bool smokingArea;
    bool wifi;

    Fields({
        // required this.id,
        required this.menu,
        required this.category,
        required this.restaurantName,
        required this.image,
        required this.city,
        required this.price,
        required this.rating,
        required this.specialized,
        required this.takeaway,
        required this.delivery,
        required this.outdoor,
        required this.smokingArea,
        required this.wifi,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        // id: json["id"],
        menu: json["menu"],
        category: json["category"],
        restaurantName: json["restaurant_name"],
        image: json["image"],
        city: cityValues.map[json["city"]]!,
        price: json["price"],
        rating: json["rating"]?.toDouble(),
        specialized: json["specialized"],
        takeaway: json["takeaway"],
        delivery: json["delivery"],
        outdoor: json["outdoor"],
        smokingArea: json["smoking_area"],
        wifi: json["wifi"],
    );

    Map<String, dynamic> toJson() => {
        // "id": id,
        "menu": menu,
        "category": category,
        "restaurant_name": restaurantName,
        "image": image,
        "city": cityValues.reverse[city],
        "price": price,
        "rating": rating,
        "specialized": specialized,
        "takeaway": takeaway,
        "delivery": delivery,
        "outdoor": outdoor,
        "smoking_area": smokingArea,
        "wifi": wifi,
    };
}

enum City {
    CENTRAL_JAKARTA,
    EAST_JAKARTA,
    NORTH_JAKARTA,
    SOUTH_JAKARTA,
    WEST_JAKARTA
}

final cityValues = EnumValues({
    "Central Jakarta": City.CENTRAL_JAKARTA,
    "East Jakarta": City.EAST_JAKARTA,
    "North Jakarta": City.NORTH_JAKARTA,
    "South Jakarta": City.SOUTH_JAKARTA,
    "West Jakarta": City.WEST_JAKARTA
});

enum Model {
    EXPLORE_MENU
}

final modelValues = EnumValues({
    "explore.menu": Model.EXPLORE_MENU
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
