import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
  

  Widget _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 120.0,
      toolbarHeight: 0,
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: const Color(0xffE54B4B),
      elevation: 0,
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(62.0),
        child: _SearchBottomBar(controller: _searchController, onChanged: (q) {
          context.read<ProductListingBloc>().add(SearchProductsEvent(q));
        }),
      ),
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

class _SearchBottomBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBottomBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.0,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: interRegular.copyWith(fontSize: 13.sp, color: Colors.grey),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 13.h),
            prefixIcon: Icon(Icons.search_rounded, color: const Color(0xffE54B4B), size: 20.sp),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  )
                : null,
          ),
          style: interRegular.copyWith(fontSize: 13.sp),
        ),
      ),
    );
  }
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
