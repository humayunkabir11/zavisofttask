import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zavi_soft_task/features/products/presentation/widgets/product_card.dart';

import '../../../../core/config/theme/style.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/products/product_listing_bloc.dart';




class ProductTabContent extends StatefulWidget {
  final int tabIndex;
  final Future<void> Function() onRefresh;

  const ProductTabContent({super.key, required this.tabIndex, required this.onRefresh});

  @override
  State<ProductTabContent> createState() => ProductTabContentState();
}

class ProductTabContentState extends State<ProductTabContent> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ProductListingBloc, ProductListingState>(
      builder: (context, state) {
        if (state is ProductListingLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xffE54B4B)));
        }

        if (state is ProductListingError) {
          return Center(child: Text(state.message));
        }

        final products = state is ProductListingLoaded
            ? state.forTab(widget.tabIndex)
            : <Product>[];

        return RefreshIndicator(
          color: const Color(0xffE54B4B),
          onRefresh: widget.onRefresh,
          child: products.isEmpty
              ? CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    (state is ProductListingLoaded && state.searchQuery.isNotEmpty)
                        ? 'No results found for "${state.searchQuery}"'
                        : 'No products in this category',
                    style: interRegular.copyWith(color: Colors.grey),
                  ),
                ),
              ),
            ],
          )
              : CustomScrollView(
            key: PageStorageKey<String>('tab_${widget.tabIndex}'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => ProductCard(product: products[index]),
                    childCount: products.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            ],
          ),
        );
      },
    );
  }
}