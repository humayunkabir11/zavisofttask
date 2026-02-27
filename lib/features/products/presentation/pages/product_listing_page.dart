

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:zavi_soft_task/core/common/widgets/field/custom_text_field.dart';
import 'package:zavi_soft_task/core/extensions/custom_extentions.dart';
import '../../../../core/config/theme/style.dart';
import '../../../../core/di/init_dependencies.dart';
import '../../domain/entities/product_entity.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../bloc/products/product_listing_bloc.dart';
import '../widgets/product_card.dart';

class ProductListingPage extends StatelessWidget {
  final UserEntity user;

  const ProductListingPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductListingBloc>()..add(LoadAllProductsEvent()),
      child: _ProductListingView(user: user),
    );
  }
}

class _ProductListingView extends StatefulWidget {
  final UserEntity user;
  const _ProductListingView({required this.user});

  @override
  State<_ProductListingView> createState() => _ProductListingViewState();
}

class _ProductListingViewState extends State<_ProductListingView>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<ProductListingBloc>().add(RefreshAllProductsEvent());
    await context.read<ProductListingBloc>().stream.firstWhere(
          (s) => s is! ProductListingLoading,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductListingBloc, ProductListingState>(
      listener: (context, state) {
        if (state is ProductListingLoaded) {
          final tabLength = state.categories.length + 1;
          if (_tabController == null || _tabController!.length != tabLength) {
            _tabController?.dispose();
            _tabController = TabController(length: tabLength, vsync: this);
          }
        }
      },
      builder: (context, state) {
        if (state is ProductListingError) {
          if (_tabController == null) {
            return _buildErrorState(state.message);
          } else {
            // Show error but keep existing data if any (or simple error view)
            // For now, if there's an error, just show the error state properly.
            return _buildErrorState(state.message);
          }
        }

        if (state is ProductListingInitial || (state is ProductListingLoading && _tabController == null)) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Color(0xffE54B4B))),
          );
        }

        if (state is ProductListingLoaded || _tabController != null) {
          ProductListingLoaded? loadedState;
          if (state is ProductListingLoaded) {
            loadedState = state;
          } else {
            final currentState = context.read<ProductListingBloc>().state;
            if (currentState is ProductListingLoaded) {
              loadedState = currentState;
            }
          }

          if (loadedState == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Color(0xffE54B4B))),
            );
          }

          final tabs = ['All', ...loadedState.categories];

          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xffF5F5F5),
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext ctx, bool innerBoxIsScrolled) {
                  return [

                    _buildSliverAppBar(innerBoxIsScrolled),

                    ///--------------- Floating Search Bar
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: _SearchHeaderDelegate(
                        onChanged: (query) {
                          context.read<ProductListingBloc>().add(SearchProductsEvent(query));
                        },
                        controller: _searchController,
                      ),
                    ),

                    // Sticky Tab Bar
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickyTabBarDelegate(
                        tabBar: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          indicator: BoxDecoration(
                            color: const Color(0xffE54B4B),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          indicatorPadding: EdgeInsets.symmetric(vertical: 8.h),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: Colors.white,
                          unselectedLabelColor: const Color(0xff555555),
                          tabAlignment: TabAlignment.start,
                          labelStyle: interSemiBold.copyWith(fontSize: 13.sp),
                          unselectedLabelStyle: interMedium.copyWith(fontSize: 13.sp),
                          dividerColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          tabs: tabs.map((t) => Tab(text: t.capitalizeFirstLetter)).toList(),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(
                    tabs.length,
                    (index) => _ProductTabContent(
                      tabIndex: index,
                      onRefresh: _onRefresh,
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
            Gap(12.h),
            Text(message, textAlign: TextAlign.center, style: interRegular.copyWith(color: Colors.grey)),
            Gap(12.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffE54B4B),
                foregroundColor: Colors.white,
              ),
              onPressed: () => context.read<ProductListingBloc>().add(LoadAllProductsEvent()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 120.0,
      pinned: false,
      floating: false,
      snap: false,
      backgroundColor: const Color(0xffE54B4B),
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: _BannerContent(user: widget.user),
      ),

    );
  }
}

class _BannerContent extends StatelessWidget {
  final UserEntity user;
  const _BannerContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffE54B4B), Color(0xffC0392B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: Colors.white24,
                child: Text(
                  user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : 'U',
                  style: interBold.copyWith(fontSize: 14.sp, color: Colors.white),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hello, ${user.fullName}',
                    style: interSemiBold.copyWith(fontSize: 14.sp, color: Colors.white),
                  ),
                  Text(
                    user.email,
                    style: interRegular.copyWith(fontSize: 11.sp, color: Colors.white.withAlpha(200)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Function(String) onChanged;
  final TextEditingController controller;

  _SearchHeaderDelegate({required this.onChanged, required this.controller});

  @override
  double get minExtent =>  80.h;
  @override
  double get maxExtent =>  80.0.h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      height: 80.h,
      alignment: Alignment.center,
      color: const Color(0xffE54B4B),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: CustomTextField(
        hintText: 'Search products...',
        controller: controller,
        borderRadius: 8,
        filledColor: Colors.white,
        enabled: true,
        onChanged: onChanged,
        prefixIcon: Icon(Icons.search_rounded, color: Colors.grey, size: 20.sp),
        suffixIcon: controller.text.isNotEmpty? IconButton(
          icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
          onPressed: () {
            controller.clear();
            onChanged('');
          },
        ) : SizedBox(),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) => true;
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _StickyTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => 46.0;
  @override
  double get maxExtent => 46.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height:46.0,
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate old) => old.tabBar != tabBar;
}

class _ProductTabContent extends StatefulWidget {
  final int tabIndex;
  final Future<void> Function() onRefresh;

  const _ProductTabContent({required this.tabIndex, required this.onRefresh});

  @override
  State<_ProductTabContent> createState() => _ProductTabContentState();
}

class _ProductTabContentState extends State<_ProductTabContent>
    with AutomaticKeepAliveClientMixin {
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
