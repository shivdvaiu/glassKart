import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eye_glass_store/data/app_locator/app_locator.dart';
import 'package:eye_glass_store/data/models/product/product.dart';
import 'package:eye_glass_store/ui/resources/app_assets/app_assets.dart';
import 'package:eye_glass_store/ui/resources/app_themes/app_theme.dart';
import 'package:eye_glass_store/ui/resources/responsive/responsive.dart';
import 'package:eye_glass_store/ui/view_models/home_view_model/home_view_model.dart';
import 'package:eye_glass_store/ui/widgets/primary_elevated_btn/primary_elevated_btn.dart';
import 'package:eye_glass_store/ui/widgets/product_card/product_card.dart';
import 'package:eye_glass_store/ui/widgets/shimmer_image/shimmer_image.dart';
import 'package:eye_glass_store/utils/constants/app_constants/app_constants.dart';
import 'package:eye_glass_store/utils/utilities/dialogs/circular_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  /// using shared prefs
  List<Products> cartProducts = [];

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var homeViewProvider = context.read<HomeViewModel>();
    FirebaseAuth firebaseAuth = locator.get<FirebaseAuth>();
    return Scaffold(
      bottomNavigationBar: PrimaryElevatedBtn(
        buttonText: 'Check Out',
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: FirebaseAuth.instance.currentUser != null
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(AppConstants.cart)
                  .doc(firebaseAuth.currentUser!.uid)
                  .collection(AppConstants.cartProducts)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  );
                }

                var cartProducts = List.generate(
                    snapshot.data.docs.length,
                    (index) => Products.fromJson(snapshot.data.docs[index]
                        .data() as Map<String, dynamic>));
                // if (cartProducts.isEmpty) {
                //   Navigator.pop(context);
                // }
                return ListView.builder(
                    itemCount: cartProducts.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _card(textTheme, colorScheme, context,
                            cartProducts[i], homeViewProvider, i),
                      );
                    });
              },
            )
          : ListView.builder(
              itemCount: locator
                      .get<SharedPreferences>()
                      .getStringList(AppConstants.cart)
                      ?.length ??
                  0,
              itemBuilder: (context, i) {
                var cartList = locator
                    .get<SharedPreferences>()
                    .getStringList(AppConstants.cart);

                cartProducts = cartList!
                    .map((i) => Products.fromJson(jsonDecode(i)))
                    .toList();

               
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _card(textTheme, colorScheme, context, cartProducts[i],
                      homeViewProvider, i),
                );
              }),
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, color: colorScheme.secondary),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Cart",
            textAlign: TextAlign.center,
            style: textTheme.headline2!.copyWith(
              color: colorScheme.secondary,
              fontSize: Responsive.isMobile(context) ? 13.sp : 4.sp,
            ),
          )),
    );
  }

  Widget _card(TextTheme textTheme, ColorScheme colorScheme, context,
      Products product, homeViewProvider, index) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: CachedImage(product.productImage!, height: 13.h),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 23,
              ),
              Text(product.productName!,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: textTheme.headline2!.copyWith(
                    color: colorScheme.primary,
                    fontSize: Responsive.isMobile(context) ? 10.sp : 3.sp,
                    letterSpacing: 0.50,
                  )),
              SizedBox(height: 10),
              Text("Product Brand:",
                  style: textTheme.labelMedium!.copyWith(
                      fontSize: Responsive.isMobile(context) ? 9.sp : 3.sp,
                      color: AppThemes.greyThree)),
              SizedBox(
                width: 3,
              ),
              Text(product.productBrand!,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.isMobile(context) ? 8.sp : 3.sp,
                      color: colorScheme.onPrimary)),
              SizedBox(height: 4),
              Text("Product Price:",
                  style: textTheme.labelMedium!.copyWith(
                      fontSize: Responsive.isMobile(context) ? 8.sp : 3.sp,
                      color: AppThemes.greyThree)),
              SizedBox(
                width: 3,
              ),
              Text(product.productPrice!,
                  style: textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.isMobile(context) ? 8.sp : 3.sp,
                      color: colorScheme.onPrimary)),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            if (FirebaseAuth.instance.currentUser != null) {
              FirebaseFirestore.instance
                  .collection(AppConstants.cart)
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection(AppConstants.cartProducts)
                  .doc(product.productId)
                  .delete();
            } else {
              var cartList = locator
                  .get<SharedPreferences>()
                  .getStringList(AppConstants.cart);
              cartProducts.removeAt(index);
              cartList!.removeAt(index);

              locator
                  .get<SharedPreferences>()
                  .setStringList(AppConstants.cart, cartList);
                  setState(() {
                    
                  });
            }
          },
          icon: Image.asset(AppAssets.deleteIcon2, height: 22),
        )
      ]),
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 6,
            color: Color.fromRGBO(0, 0, 0, 0.16),
          )
        ],
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: AppThemes.lightColor,
          width: 1,
        ),
        color: Colors.white,
      ),
    );
  }
}
