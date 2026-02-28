import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/product_entity.dart';
import '../../../../core/config/theme/style.dart';

/// ---------------------  A card widget displaying a single product.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.black.withAlpha(15), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///-------------------------------------  Product Image -------------------
            Expanded(
              flex: 3,
              child: _ProductImage(imageUrl: product.image, tag: product.id.toString()),
            ),

            ///-------------------------------- Product Info -------------------
            Expanded(
              flex: 2,
              child: _ProductInfo(product: product),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const _ProductImage({required this.imageUrl, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: tag,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              placeholder: (_, __) => Container(
                color: const Color(0xffF9F9F9),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xffE54B4B)),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                color: const Color(0xffF9F9F9),
                child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 30),
              ),
            ),
          ),
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: Container(
            padding: EdgeInsets.all(6.r),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.favorite_border, size: 16.sp, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final Product product;

  const _ProductInfo({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.category.toUpperCase(),
            style: interSemiBold.copyWith(
              fontSize: 10.sp,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: interMedium.copyWith(
              fontSize: 13.sp,
              color: const Color(0xff1A1A1A),
              height: 1.3,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: interBold.copyWith(
                  fontSize: 15.sp,
                  color: const Color(0xffE54B4B),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.amber, size: 16.sp),
                  SizedBox(width: 4.w),
                  Text(
                    product.ratingRate.toStringAsFixed(1),
                    style: interSemiBold.copyWith(
                      fontSize: 12.sp,
                      color: const Color(0xff444444),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

