import 'package:eye_glass_store/ui/resources/app_assets/app_assets.dart';
import 'package:eye_glass_store/ui/resources/app_themes/app_theme.dart';
import 'package:eye_glass_store/ui/resources/responsive/responsive.dart';
import 'package:eye_glass_store/ui/widgets/shimmer_image/shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProductCard extends StatelessWidget {
  final String productName,
      productPrice,
      productImage,
      productSalePercent,
      productOldPrice,
      productBrand;
  final bool haveRatings;

  final VoidCallback? onTap;
  final Function()? addToCart;
  ProductCard(
      {required this.productName,
      this.onTap,
      required this.productPrice,
      this.haveRatings = false,
      required this.productImage,
      this.addToCart,
      required this.productBrand,
      required this.productOldPrice,
      required this.productSalePercent});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
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
              color: Color(0xffeaefff),
              width: 1,
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productBrand,
                style: textTheme.headline1!.copyWith(
                    fontSize: Responsive.isMobile(context) ? 10.sp : 4.sp,
                    letterSpacing: 0.50,
                    color: Colors.black),
              ),
              Container(
                width: 129,
                height: 129,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: CachedImage(
                      productImage,
                      height: 129,
                      width: 129,
                      radius: 9,
                    )),
              ),
              SizedBox(height: 8),
              Container(
                width: 100,
                child: Text(productName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: textTheme.headline2!.copyWith(
                      fontSize: Responsive.isMobile(context) ? 8.sp : 3.sp,
                      letterSpacing: 0.50,
                    )),
              ),
              SizedBox(height: 4),
              ...[
                if (haveRatings)
                  Row(
                    children: [
                      ...List.generate(
                        3,
                        (i) => Icon(
                          Icons.star_outlined,
                          size: 2.h,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      Icon(
                        Icons.star_half_outlined,
                        size: 2.h,
                        color: colorScheme.onPrimary,
                      ),
                    ],
                  )
              ],
              SizedBox(height: 8),
              Text(
                productPrice,
                style: textTheme.headline1!.copyWith(
                    fontSize: Responsive.isMobile(context) ? 8.sp : 4.sp,
                    letterSpacing: 0.50,
                    color: colorScheme.onSecondary),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "₹${productOldPrice}",
                    style: textTheme.bodyText1!.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: colorScheme.secondaryContainer,
                        fontSize: Responsive.isMobile(context) ? 7.sp : 3.sp,
                        letterSpacing: 0.50),
                  ),
                  SizedBox(width: 8),
                  Text("24% Off",
                      style: textTheme.headline1!.copyWith(
                        color: colorScheme.onPrimary,
                        fontSize: Responsive.isMobile(context) ? 8.sp : 3.sp,
                        letterSpacing: 0.50,
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: addToCart, child: _addToCartButton(textTheme,context))
            ],
          ),
        ),
      ),
    );
  }

  Container _addToCartButton(TextTheme textTheme,context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "Add to cart",
            style: textTheme.headline1!
                .copyWith(fontSize: Responsive.isMobile(context) ? 10.sp:4.sp, color: Colors.white),
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppThemes.borderColor,
          width: 1,
        ),
        color: Color(0xff125B50),
      ),
    );
  }
}
