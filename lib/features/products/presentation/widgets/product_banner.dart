import 'package:flutter/material.dart';
import '../../../login/domain/entities/user_entity.dart';

class ProductBanner extends StatelessWidget {

  const ProductBanner({super.key, });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/product_banner.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withAlpha(60),
                Colors.black.withAlpha(110),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}
