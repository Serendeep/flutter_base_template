import 'package:flutter/material.dart';
import 'package:flutter_base_template/utils/theme/theme.dart';

class LoadingDialogIndicator extends StatelessWidget {
  const LoadingDialogIndicator({
    super.key,
    required this.mediaSize,
  });

  final Size mediaSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: mediaSize.width * 0.4,
            vertical: mediaSize.height * 0.4),
        height: 40.0,
        width: 40.0,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: CircularProgressIndicator.adaptive(
          backgroundColor:
              ThemeColor.get(context).primaryAccent.withOpacity(0.3),
        ),
      ),
    );
  }
}
