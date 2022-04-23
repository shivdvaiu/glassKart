import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  final String? productName,
      productPrice,
      productBrand,
      productOldPrice,
      productImage,
      productId;

  Products(
      {this.productName,
      this.productPrice,
      this.productId,
      this.productBrand,
      this.productImage,
      this.productOldPrice,
   });

  static Products fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Products(
        productName: snapshot["productName"],
        productPrice: snapshot["productPrice"],
        productBrand: snapshot["productBrand"],
        productId: snapshot["productId"],
        productOldPrice: snapshot["productOldPrice"],
        productImage: snapshot["productImage"]);
  }

  static Products fromJson(Map<String, dynamic> json) {
    return Products(
        productBrand: json['productBrand'],
        productName: json["productName"],
        productId: json["productId"],
        productPrice: json["productPrice"],
        productOldPrice: json["productOldPrice"],
        productImage: json['productImage']);
  }

  Map<String, dynamic> toJson() => {
        "productName": productName,
        "productId":productId,
        "productBrand": productBrand,
        "productPrice": productPrice,
        "productOldPrice": productOldPrice,
        "productImage": productImage
      };
}
