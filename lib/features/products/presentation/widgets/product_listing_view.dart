import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zavi_soft_task/core/extensions/custom_extentions.dart';
import 'package:zavi_soft_task/features/products/presentation/widgets/product_banner.dart';
import 'package:zavi_soft_task/features/products/presentation/widgets/product_search_bar.dart';
import 'package:zavi_soft_task/features/products/presentation/widgets/product_tab_content.dart';
import 'package:zavi_soft_task/features/products/presentation/widgets/sticky_tab_bar_delegate.dart';

import '../../../../core/config/theme/style.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../bloc/products/product_listing_bloc.dart';

class ProductListingView extends StatefulWidget {
  final UserEntity user;
  const ProductListingView({super.key, required this.user});

  @override
  State<ProductListingView> createState() => ProductListingViewState();
}

class ProductListingViewState extends State<ProductListingView> with TickerProviderStateMixin {
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
        if (state is ProductListingInitial ||
            (state is ProductListingLoading && _tabController == null)) {
          return const Scaffold(
            body: Center(
                child: CircularProgressIndicator(color: Color(0xffE54B4B))),
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
              body: Center(
                  child: CircularProgressIndicator(color: Color(0xffE54B4B))),
            );
          }

          final tabs = ['All', ...loadedState.categories];

          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xffF5F5F5),
              body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext ctx, bool innerBoxIsScrolled) {
                  return [
                    _buildSliverAppBar(innerBoxIsScrolled),

                    ///--------------------------- Sliver Sticky Tab Bar
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: StickyTabBarDelegate(
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
                          labelStyle: interSemiBold.copyWith(fontSize: 12.sp),
                          unselectedLabelStyle:
                          interMedium.copyWith(fontSize: 12.sp),
                          dividerColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          tabs: tabs
                              .map((t) => Tab(text: t.capitalizeFirstLetter))
                              .toList(),
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
                        (index) => ProductTabContent(
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
///-------------------------- banner & sliver app bar
  Widget _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 140.0,
      toolbarHeight: 0,
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: const Color(0xffE54B4B),
      elevation: 0,
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(62.0),
        child: ProductSearchBar(
            controller: _searchController,
            onChanged: (q) {
              context.read<ProductListingBloc>().add(SearchProductsEvent(q));
            }),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: ProductBanner(),
      ),
    );
  }
}