import 'package:flutter/material.dart';
import 'package:flutter_base_template/utils/config/flavor_config.dart';
import 'package:flutter_base_template/utils/constants.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;

  const FlavorBanner({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (FlavorConfig.instance.flavor == Flavor.production) {
      return child;
    }

    return Banner(
      location: BannerLocation.topEnd,
      message: FlavorConfig.instance.flavor.name.toTitleCase,
      color: _getBannerColor(),
      child: child,
    );
  }

  Color _getBannerColor() {
    switch (FlavorConfig.instance.flavor) {
      case Flavor.development:
        return Colors.green.withOpacity(0.6);
      case Flavor.staging:
        return Colors.orange.withOpacity(0.6);
      case Flavor.production:
        return Colors.transparent;
    }
  }
}
