import 'package:flutter/material.dart';
import 'package:flutter_base_template/utils/widgets/back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {this.trailingWidget,
      this.mainWidget,
      this.isBackDisabled = false,
      this.leadingIcon,
      this.leadingOnTap,
      super.key});
  final IconData? leadingIcon;
  final Function()? leadingOnTap;
  final Widget? trailingWidget;
  final Widget? mainWidget;
  final bool isBackDisabled;
  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SizedBox(
        height: mediaSize.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            !isBackDisabled
                ? CustomBackButton(
                    icon: leadingIcon,
                    onTap: leadingOnTap,
                  )
                : const SizedBox(width: 40.0),
            mainWidget ?? const SizedBox(width: 40),
            trailingWidget ?? const SizedBox(width: 40)
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 135);
}
