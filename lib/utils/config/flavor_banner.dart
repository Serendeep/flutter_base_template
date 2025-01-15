import 'package:flutter/material.dart';
import 'package:flutter_base_template/utils/config/flavor_config.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;

  const FlavorBanner({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (FlavorConfig.instance.flavor == Flavor.production) {
      return child;
    }

    return Banner(
      location: BannerLocation.topEnd,
      message: FlavorConfig.instance.flavor.name,
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
