import 'package:eye_glass_store/ui/resources/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SecondaryElevatedBtn extends StatelessWidget {
  final String buttonText;
  final String leadingIcon;
  final VoidCallback onPressed;

  SecondaryElevatedBtn(
      {required this.buttonText,
      required this.onPressed,
      required this.leadingIcon});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Color(0xffeaefff),
            width: 1,
          ),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            minimumSize: MaterialStateProperty.all(
                Size(Responsive.isMobile(context)?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width/2, 60)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
             elevation: MaterialStateProperty.all(10),
             
            shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
            
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(leadingIcon, height: 30),
                SizedBox(width: 5,),
                Text(buttonText,
                    style: textTheme.headline1!.copyWith(fontSize: Responsive.isMobile(context)? 11.sp:4.sp,color:colorScheme.secondaryContainer)),
                Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
