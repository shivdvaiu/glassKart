import 'package:eye_glass_store/ui/resources/app_themes/app_theme.dart';
import 'package:eye_glass_store/ui/resources/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PrimaryElevatedBtn extends StatelessWidget {
  final String buttonText;
  final bool buttonTypeTwo;
  final VoidCallback onPressed;

  PrimaryElevatedBtn({
    required this.buttonText,
    this.buttonTypeTwo = false,
    required this.onPressed,
  });
 

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 14),
        decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: AppThemes.primaryGradient,
              ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            minimumSize: MaterialStateProperty.all(Size(
                Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 2,
                60)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            // elevation: MaterialStateProperty.all(3),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Text(buttonText,
                style: textTheme.headline2!.copyWith(
                    color: colorScheme.background,
                    fontSize: Responsive.isMobile(context) ? 12.sp : 4.sp)),
          ),
        ),
      ),
    );
  }
}
