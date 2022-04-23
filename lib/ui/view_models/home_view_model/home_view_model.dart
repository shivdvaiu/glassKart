import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eye_glass_store/data/models/product/product.dart';
import 'package:eye_glass_store/utils/constants/app_constants/app_constants.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  List<Products> allProducts = [];
  List<Products> searchedProducts = [];
  List<String> allCategoriesId = [];
  List<String> allCategoriesNames = [];

  searchedProduct({required String query}) {
    if (query.isNotEmpty) {
      allProducts = searchedProducts.where((element) {
        return element.productName!.toLowerCase().contains(query);
      }).toList();
      notifyListeners();
    }
  }

  Future<dynamic> addToCart({
    required userId,
    required Products product,
  }) async {
    await FirebaseFirestore.instance
        .collection(AppConstants.cart)
        .doc(userId)
        .collection("cartProducts")
        .doc(product.productId)
        .set(product.toJson(), SetOptions(merge: true));
    return;
  }




}
