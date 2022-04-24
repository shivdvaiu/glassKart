import 'dart:developer';

import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:eye_glass_store/data/app_locator/app_locator.dart';
import 'package:eye_glass_store/data/models/product/product.dart';
import 'package:eye_glass_store/data/models/user_model/user_model.dart';
import 'package:eye_glass_store/ui/pages/home_screen/cart_screen/cart_screen.dart';
import 'package:eye_glass_store/ui/resources/app_assets/app_assets.dart';
import 'package:eye_glass_store/ui/resources/app_dimensions/app_dimensions.dart';
import 'package:eye_glass_store/ui/resources/responsive/responsive.dart';
import 'package:eye_glass_store/ui/view_models/auth/auth_view_model.dart';
import 'package:eye_glass_store/ui/view_models/home_view_model/home_view_model.dart';
import 'package:eye_glass_store/ui/widgets/advanced_drawer/advanced_drawer.dart';
import 'package:eye_glass_store/ui/widgets/custom_text_field.dart/text_field.dart';
import 'package:eye_glass_store/ui/widgets/product_card/product_card.dart';
import 'package:eye_glass_store/ui/widgets/shimmer_image/shimmer_image.dart';
import 'package:eye_glass_store/utils/constants/app_constants/app_constants.dart';
import 'package:eye_glass_store/utils/utilities/dialogs/circular_dialog.dart';
import 'package:eye_glass_store/utils/utilities/routes/routes.dart';
import 'package:eye_glass_store/utils/utilities/snack_bar/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart' as drawer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> sliderImages = [];
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  int currentBannerIndex = 0;
  final _advancedDrawerController = drawer.AdvancedDrawerController();

  FirebaseAuth firebaseAuth = locator.get<FirebaseAuth>();
  TextEditingController searchProductController = TextEditingController();
  SharedPreferences pref = locator.get<SharedPreferences>();
  @override
  Widget build(BuildContext context) {
    var homeViewProvider = context.read<HomeViewModel>();
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return AdvancedDrawer(
      openRatio: 0.60,
      controller: _advancedDrawerController,
      childDecoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      drawer: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 40,
          ),
          FirebaseAuth.instance.currentUser != null
              ? BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: new UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(13)),
                    currentAccountPicture: new CircleAvatar(
                      radius: 50.0,
                      backgroundColor: colorScheme.primary,
                      backgroundImage: NetworkImage(
                          "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png"),
                    ),
                    accountEmail: Text(firebaseAuth.currentUser!.email!,
                        style: textTheme.headline1!
                            .copyWith(fontSize: 8.sp, color: Colors.white)),
                    accountName: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(AppConstants.users)
                          .doc(firebaseAuth.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox();
                        }

                        UserModel user = UserModel.fromSnap(snapshot.data);

                        return Text(user.username,
                            style: textTheme.headline1!.copyWith(
                                fontSize: 11.sp, color: Colors.white));
                      },
                    ),
                  ),
                )
              : SizedBox(),
          SizedBox(
            height: 10.h,
          ),
          TextButton(
              onPressed: () {
                SharedPreferences prefs = locator.get<SharedPreferences>();

                context.read<AuthViewModel>().logOut().then((value) {
                  prefs.clear();
                  Navigator.pushReplacementNamed(context, Routes.loginScreen);
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FirebaseAuth.instance.currentUser != null
                      ? Text("Logout",
                          style: textTheme.headline1!
                              .copyWith(fontSize: 14.sp, color: Colors.white))
                      : Text("Login",
                          style: textTheme.headline1!
                              .copyWith(fontSize: 14.sp, color: Colors.white)),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                  )
                ],
              )),
        ]),
      ),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(AppConstants.productsCategory)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            );
          }

          homeViewProvider.allCategoriesNames =
              List.generate(snapshot.data.docs.length, (i) {
            return snapshot.data.docs[i].data()["category"];
          });

          homeViewProvider.allCategoriesId =
              List.generate(snapshot.data.docs.length, (i) {
            return snapshot.data.docs[i].data()["categoryId"];
          });
          // context.read<HomeViewModel>().getAllProducts(snapshot);

          return DefaultTabController(
            length: snapshot.data.docs.length,
            child: Scaffold(
              appBar: AppBar(
                  actions: [
                    IconButton(
                        onPressed: () {
                          showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) => CartScreen(),
                          );
                        },
                        icon: Image.asset(
                          AppAssets.cart,
                          height: 30,
                        ))
                  ],
                  leading: IconButton(
                    onPressed: () {
                      _advancedDrawerController.showDrawer();
                    },
                    icon:
                        Icon(Icons.apps_outlined, color: colorScheme.secondary),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: Text(
                    "GlassKart",
                    textAlign: TextAlign.center,
                    style: textTheme.headline2!.copyWith(
                      color: colorScheme.secondary,
                      fontSize: Responsive.isMobile(context) ? 13.sp : 4.sp,
                    ),
                  )),
              body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      CarouselSlider.builder(
                          options: CarouselOptions(
                            aspectRatio:
                                Responsive.isMobile(context) ? 10 / 4 : 4 / 1,
                            viewportFraction: 0.8,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {},
                            scrollDirection: Axis.horizontal,
                          ),
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: sliderImages.isEmpty
                                  ? FlutterLogo()
                                  : AspectRatio(
                                      aspectRatio: Responsive.isMobile(context)
                                          ? 10 / 7
                                          : 4 / 1,
                                      child: CachedImage(
                                        sliderImages[index],
                                        radius: 8,
                                      ),
                                    ),
                            );
                          },
                          itemCount: sliderImages.length),
                      sHeightSpan,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Categories",
                              style: textTheme.headline1!.copyWith(
                                  fontSize: Responsive.isMobile(context)
                                      ? 11.sp
                                      : 4.sp),
                            ),
                          ],
                        ),
                      ),
                      TabBar(
                          onTap: (index) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _counter.value += 1;
                            searchProductController.clear();
                          },
                          labelStyle: textTheme.headline2!.copyWith(
                              fontSize:
                                  Responsive.isMobile(context) ? 11.sp : 4.sp,
                              fontWeight: FontWeight.w600),
                          indicatorSize: TabBarIndicatorSize.label,
                          unselectedLabelStyle: textTheme.headline2!.copyWith(
                              fontSize:
                                  Responsive.isMobile(context) ? 10.sp : 3.sp,
                              fontWeight: FontWeight.w600),
                          labelColor: colorScheme.primary,
                          indicatorColor: colorScheme.secondary,
                          tabs: [
                            ...List.generate(
                                homeViewProvider.allCategoriesNames.length,
                                (i) => Tab(
                                      child: _tabText(
                                        textTheme,
                                        homeViewProvider.allCategoriesNames[i],
                                      ),
                                    )),
                          ]),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextField(
                            onChanged: (value) {
                              homeViewProvider.searchedProduct(
                                  query: value.toLowerCase());
                            },
                            prefixIcon:
                                Icon(Icons.search, color: colorScheme.primary),
                            controller: searchProductController,
                            hintText: 'Search Products',
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: TabBarView(children: [
                          ...List.generate(snapshot.data.docs.length, (i) {
                            var productsCategoryData = snapshot.data.docs[i]
                                .data() as Map<String, dynamic>;
                            ;

                            return ValueListenableBuilder<int>(
                                valueListenable: _counter,
                                builder: (context, value, child) =>
                                    StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection(
                                              AppConstants.productsCategory)
                                          .doc(productsCategoryData[
                                                  AppConstants.categoryId]
                                              .toString()
                                              .trim())
                                          .collection(AppConstants.product)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic>
                                              productSnapshot) {
                                        if (productSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: colorScheme.primary,
                                            ),
                                          );
                                        }

                                        homeViewProvider.allProducts =
                                            List.generate(
                                                productSnapshot
                                                    .data.docs.length,
                                                (index) => Products.fromJson(
                                                    productSnapshot
                                                            .data.docs[index]
                                                            .data()
                                                        as Map<String,
                                                            dynamic>));

                                        homeViewProvider.searchedProducts =
                                            List.generate(
                                                productSnapshot
                                                    .data.docs.length,
                                                (index) => Products.fromJson(
                                                    productSnapshot
                                                            .data.docs[index]
                                                            .data()
                                                        as Map<String,
                                                            dynamic>));

                                        return Consumer<HomeViewModel>(
                                          builder: (BuildContext context,
                                              homeViewModel, Widget? child) {
                                            return StaggeredGridView
                                                .countBuilder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              crossAxisCount:
                                                  Responsive.isMobile(context)
                                                      ? 2
                                                      : 4,
                                              itemCount: homeViewModel
                                                  .allProducts.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                if (homeViewProvider
                                                    .allProducts.isNotEmpty) {
                                                  sliderImages.add(
                                                      homeViewProvider
                                                          .allProducts[index]
                                                          .productImage!);
                                                }

                                                return homeViewProvider
                                                        .allProducts.isNotEmpty
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: ProductCard(
                                                          addToCart: () {
                                                            if (FirebaseAuth
                                                                    .instance
                                                                    .currentUser !=
                                                                null) {
                                                              showCircularProgressBar(
                                                                  context:
                                                                      context);
                                                              homeViewModel
                                                                  .addToCart(
                                                                userId: firebaseAuth
                                                                    .currentUser!
                                                                    .uid,
                                                                product:
                                                                    homeViewModel
                                                                            .allProducts[
                                                                        index],
                                                              )
                                                                  .then(
                                                                      (value) {
                                                                Navigator.pop(
                                                                    context);

                                                                showSnackBar(
                                                                    context,
                                                                    "${homeViewModel.allProducts[index].productName!} added to cart");
                                                              });
                                                            } else {
                                                              showCircularProgressBar(
                                                                  context:
                                                                      context);
                                                              homeViewModel
                                                                  .addToCartUsingSharedPref(
                                                                product:
                                                                    homeViewModel
                                                                            .allProducts[
                                                                        index],
                                                              )
                                                                  .then(
                                                                      (value) {
                                                                Navigator.pop(
                                                                    context);

                                                                showSnackBar(
                                                                    context,
                                                                    "${homeViewModel.allProducts[index].productName!} added to cart");
                                                              });
                                                            }
                                                          },
                                                          onTap: () {},
                                                          productName:
                                                              homeViewModel
                                                                  .allProducts[
                                                                      index]
                                                                  .productName!,
                                                          productImage:
                                                              homeViewModel
                                                                  .allProducts[
                                                                      index]
                                                                  .productImage!,
                                                          productOldPrice:
                                                              homeViewModel
                                                                  .allProducts[
                                                                      index]
                                                                  .productOldPrice!,
                                                          productPrice:
                                                              homeViewModel
                                                                  .allProducts[
                                                                      index]
                                                                  .productPrice!,
                                                          productSalePercent:
                                                              "24% Off",
                                                          productBrand:
                                                              homeViewModel
                                                                  .allProducts[
                                                                      index]
                                                                  .productBrand!,
                                                        ),
                                                      )
                                                    : Center(
                                                        child: Text(
                                                        "No Products Found",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ));
                                              },
                                              staggeredTileBuilder:
                                                  (int index) =>
                                                      new StaggeredTile.fit(1),
                                            );
                                          },
                                        );
                                      },
                                    ));
                          })
                        ]),
                      )
                    ]),
              ),
              backgroundColor: colorScheme.background,
            ),
          );
        },
      ),
    );
  }

  Text _tabText(TextTheme textTheme, text) {
    return Text(
      text,
    );
  }
}
