import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:klackr_mobile/utils/theme/theme.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({this.icon, this.onTap, super.key});
  final IconData? icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (context.canPop()) context.pop();
          },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                offset: Offset(0.1, 0.2),
                blurRadius: 15.0,
                color: Colors.black26)
          ],
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
              color: ThemeColor.get(context).textfieldBorderColor, width: 0.5),
        ),
        child: Icon(icon ?? Icons.arrow_back,
            size: 22, color: ThemeColor.get(context).primaryAccent),
      ),
    );
  }
}
