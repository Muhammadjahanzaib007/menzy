class Product {
  int? id;
  String? name;
  String? image;
  String? description;
  int? stock;
  int? price;
  int? status;
  String? createdAt;
  String? updatedAt;

  Product(
      {this.id,
        this.name,
        this.image,
        this.description,
        this.stock,
        this.price,
        this.status,
        this.createdAt,
        this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    stock = json['stock'];
    price = json['price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['stock'] = this.stock;
    data['price'] = this.price;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}