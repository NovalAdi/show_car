import 'package:show_car/const/api_config.dart';

class Car {
  final int? id;
  final String? name;
  final String? brand;
  final String? price;
  final String? desc;
  final String? image;

  Car({
    this.id,
    this.name,
    this.brand,
    this.price,
    this.desc,
    this.image,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      price: json['price'],
      desc: json['desc'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['brand'] = brand;
    data['price'] = price;
    data['desc'] = desc;
    data['image'] = image;
    return data;
  }
}
