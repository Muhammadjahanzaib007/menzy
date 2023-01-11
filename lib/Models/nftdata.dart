class NFTData {
  int? id;
  String? name;
  String? description;
  String? price;
  String? imgPath;
  String? imageCategory;
  String? createdAt;
  String? updatedAt;
  int? status;

  NFTData(
      {this.id,
        this.name,
        this.description,
        this.price,
        this.imgPath,
        this.imageCategory,
        this.createdAt,
        this.status,
        this.updatedAt});

  NFTData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    imgPath = json['compressed'];
    status = json['status'];
    imageCategory = json['image_category'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['img_path'] = this.imgPath;
    data['image_category'] = this.imageCategory;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}