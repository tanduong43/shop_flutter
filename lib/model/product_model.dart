class Productmodel {
  int id;
  String name;
  double price;
  String image;
  String short_description;
  Productmodel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.short_description,
  });
  factory Productmodel.fromJson(Map<String, dynamic> json) {
    return Productmodel(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      image: json["image"],
      short_description: json["short_description"],
    );
  }
}
