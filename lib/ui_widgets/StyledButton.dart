
import 'package:diary/theme.dart';
import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {

  const StyledButton({required this.child, required this.onPressed, super.key});

  final Widget child;
  final Function() onPressed;


  @override
  Widget build(BuildContext context) {
     return TextButton(
         onPressed: onPressed,
         style:TextButton.styleFrom(
           backgroundColor: AppColors.secondaryPurple,
           foregroundColor: AppColors.textWhite,
           minimumSize: Size(120, 48),
         ),

         child: child
     );
  }
}



class StyledEmojiButton extends StatelessWidget {
  const StyledEmojiButton({super.key, required this.emoji, required this.onPressed, required this.isSelected } );

  final String emoji;
  final Function() onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ,
      child: Text(emoji, style: TextStyle(fontSize: 32)),
      style: TextButton.styleFrom(
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        backgroundColor: isSelected == true ? AppColors.textOffwhite : AppColors.lightPink,
        foregroundColor: AppColors.textWhite,
        minimumSize: Size(60, 60),
      ),
    );
  }
}

class StyledButtonLite extends StatelessWidget {
  const StyledButtonLite({super.key, required this.child, required this.onPressed});

  final Widget child;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {

    return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: AppColors.lightPink,
          foregroundColor: AppColors.textWhite,
          minimumSize: Size(120, 48),
        ),
        onPressed: onPressed,
        child: child);
  }
}