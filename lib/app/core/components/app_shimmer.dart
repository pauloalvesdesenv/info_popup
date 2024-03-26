import 'package:programacao/app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;
  final bool enable;

  const AppShimmer({Key? key, required this.child, this.enable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !enable
        ? child
        : IgnorePointer(
            ignoring: true,
            child: Shimmer.fromColors(
              baseColor: AppColors.primaryMedium,
              highlightColor: AppColors.primaryLight,
              period: const Duration(milliseconds: 800),
              child: child,
            ),
          );
  }
}
