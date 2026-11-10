import 'package:flutter/material.dart';
import 'package:yha/core/theme/app_colors.dart';
import 'package:yha/core/utils/formatters.dart';

class PriceDisplay extends StatelessWidget {
  const PriceDisplay({super.key, this.normalPrice, this.specialPrice, this.compact = false});

  final num? normalPrice;
  final num? specialPrice;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final hasSpecial = specialPrice != null && specialPrice! > 0;
    final main = hasSpecial ? specialPrice : normalPrice;
    if (main == null) return const SizedBox.shrink();
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        Text(
          formatKyat(main),
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w800,
            fontSize: compact ? 14 : 17,
          ),
        ),
        if (hasSpecial && normalPrice != null)
          Text(
            formatKyat(normalPrice),
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
}
