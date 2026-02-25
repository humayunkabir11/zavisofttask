// ╔══════════════════════════════════════════════════════════════════════╗
// ║              PRODUCT LISTING — SCROLL ARCHITECTURE                   ║
// ╠══════════════════════════════════════════════════════════════════════╣
// ║                                                                      ║
// ║  ┌─────────────────────────────────────────────────────────────────┐ ║
// ║  │ WHO OWNS VERTICAL SCROLL?                                       │ ║
// ║  │                                                                 │ ║
// ║  │ NestedScrollView is the SOLE owner of vertical scrolling.       │ ║
// ║  │                                                                 │ ║
// ║  │ It manages TWO coordinated scroll positions:                    │ ║
// ║  │   • OUTER — drives the SliverAppBar collapse/expand             │ ║
// ║  │   • INNER — drives the product list scrolling (per active tab)  │ ║
// ║  │                                                                 │ ║
// ║  │ No other widget in this tree competes for vertical events.      │ ║
// ║  │ TabBarView children use normal physics because NestedScrollView  │ ║
// ║  │ internally coordinates inner scroll positions through a special  │ ║
// ║  │ ScrollPosition — it only allows vertical movement AFTER the      │ ║
// ║  │ outer (header) has been fully consumed.                         │ ║
// ║  └─────────────────────────────────────────────────────────────────┘ ║
// ║                                                                      ║
// ║  ┌─────────────────────────────────────────────────────────────────┐ ║
// ║  │ HOW HORIZONTAL SWIPE WORKS                                      │ ║
// ║  │                                                                 │ ║
// ║  │ TabBarView (backed by PageView) exclusively owns horizontal     │ ║
// ║  │ gestures. Flutter's gesture arena resolves competing touches:   │ ║
// ║  │                                                                 │ ║
// ║  │   • Predominantly HORIZONTAL drag → PageView wins → tab switch  │ ║
// ║  │   • Predominantly VERTICAL drag  → NestedScrollView wins        │ ║
// ║  │                                                                 │ ║
// ║  │ No GestureDetector hacks or manual gesture splitting needed.    │ ║
// ║  │ Flutter's built-in physics handles the disambiguation cleanly.  │ ║
// ║  │                                                                 │ ║
// ║  │ TabController keeps TAP (tab bar) and SWIPE (PageView) in sync. │ ║
// ║  └─────────────────────────────────────────────────────────────────┘ ║
// ║                                                                      ║
// ║  ┌─────────────────────────────────────────────────────────────────┐ ║
// ║  │ PULL-TO-REFRESH                                                 │ ║
// ║  │                                                                 │ ║
// ║  │ RefreshIndicator wraps each tab's CustomScrollView directly.    │ ║
// ║  │ Reason: NestedScrollView sends scroll notifications from inner  │ ║
// ║  │ scrollables at notification depth > 0. Placing RefreshIndicator │ ║
// ║  │ at the outer level requires filtering by depth, which is        │ ║
// ║  │ fragile across Flutter versions. Per-tab RefreshIndicator is    │ ║
// ║  │ more reliable and the UX is identical — they all dispatch the   │ ║
// ║  │ same BLoC event (RefreshAllProductsEvent).                      │ ║
// ║  └─────────────────────────────────────────────────────────────────┘ ║
// ║                                                                      ║
// ║  ┌─────────────────────────────────────────────────────────────────┐ ║
// ║  │ TAB SWITCH & SCROLL POSITION                                    │ ║
// ║  │                                                                 │ ║
// ║  │ The OUTER scroll position (header collapse) is a single shared  │ ║
// ║  │ ScrollPosition — it is untouched when you switch tabs.          │ ║
// ║  │                                                                 │ ║
// ║  │ Each inner tab (CustomScrollView) has its own scroll position   │ ║
// ║  │ preserved via PageStorageKey + AutomaticKeepAliveClientMixin.   │ ║
// ║  │ Switching tabs restores the previous inner position for that    │ ║
// ║  │ tab.                                                            │ ║
// ║  │                                                                 │ ║
// ║  │ AutomaticKeepAliveClientMixin prevents the tab content from     │ ║
// ║  │ being disposed when switching tabs, so scroll position and      │ ║
// ║  │ widget state are preserved.                                     │ ║
// ║  └─────────────────────────────────────────────────────────────────┘ ║
// ╚══════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/routes/route_path.dart';
import '../../../../core/config/theme/style.dart';
import '../../../../core/di/init_dependencies.dart';
import '../../domain/entities/product_entity.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../../../login/presentation/bloc/auth/auth_bloc.dart';
import '../bloc/products/product_listing_bloc.dart';
import '../widgets/product_card.dart';

// ─── Constants ────────────────────────────────────────────────────────────────
const _kBannerHeight = 180.0; // expanded SliverAppBar content height
const _kTabBarHeight = 46.0;  // sticky tab bar height

// ─── Tab definitions — add/remove tabs here only ──────────────────────────────
const _kTabs = [
  _TabDef(label: 'All',         category: null),
  _TabDef(label: 'Electronics', category: 'electronics'),
  _TabDef(label: 'Jewelery',    category: 'jewelery'),
];

class _TabDef {
  final String label;
  final String? category;
  const _TabDef({required this.label, required this.category});
}

// ─── Page entry point ─────────────────────────────────────────────────────────

class ProductListingPage extends StatelessWidget {
  /// The authenticated user, passed from LoginPage after successful auth.
  final UserEntity user;

  const ProductListingPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AuthBloc is needed here only for logout action
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(
          create: (_) =>
              sl<ProductListingBloc>()..add(LoadAllProductsEvent()),
        ),
      ],
      child: _ProductListingView(user: user),
    );
  }
}

// ─── The actual view — owns TabController ────────────────────────────────────

class _ProductListingView extends StatefulWidget {
  final UserEntity user;
  const _ProductListingView({required this.user});

  @override
  State<_ProductListingView> createState() => _ProductListingViewState();
}

class _ProductListingViewState extends State<_ProductListingView>
    with SingleTickerProviderStateMixin {
  // ── SCROLL OWNERSHIP ────────────────────────────────────────────────────
  // TabController is the coordination hub between the tab bar (tap)
  // and the TabBarView (swipe). It does NOT own any scroll — it only
  // tracks which tab index is currently shown.
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _kTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Called by any tab's RefreshIndicator ─────────────────────────────────
  Future<void> _onRefresh() async {
    context.read<ProductListingBloc>().add(RefreshAllProductsEvent());
    // Wait until the BLoC emits a non-loading state
    await context.read<ProductListingBloc>().stream.firstWhere(
          (s) => s is! ProductListingLoading,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: NestedScrollView(
        // ────────────────────────────────────────────────────────────────
        // OUTER SCROLL: header slivers (collapsible banner + sticky tab bar)
        // ────────────────────────────────────────────────────────────────
        headerSliverBuilder: (BuildContext ctx, bool innerBoxIsScrolled) {
          return [
            // 1. Collapsible SliverAppBar — holds banner + search bar
            _buildSliverAppBar(innerBoxIsScrolled),

            // 2. SliverPersistentHeader(pinned: true) — tab bar stays
            //    sticky once the SliverAppBar has collapsed.
            SliverPersistentHeader(
              pinned: true, // ← this is what makes the tab bar "sticky"
              delegate: _StickyTabBarDelegate(
                tabBar: TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  indicator: BoxDecoration(
                    color: const Color(0xffE54B4B),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xff555555),
                  labelStyle: interSemiBold.copyWith(fontSize: 13.sp),
                  unselectedLabelStyle:
                      interMedium.copyWith(fontSize: 13.sp),
                  dividerColor: Colors.transparent,
                  tabs: _kTabs
                      .map((t) => Tab(text: t.label))
                      .toList(),
                ),
              ),
            ),
          ];
        },

        // ────────────────────────────────────────────────────────────────
        // INNER SCROLL: TabBarView handles horizontal navigation.
        // Each child is a CustomScrollView (inner scrollable for NestedScrollView).
        // ────────────────────────────────────────────────────────────────
        body: TabBarView(
          controller: _tabController,
          // TabBarView's physics: BouncingScrollPhysics ensures horizontal
          // swipe feels natural. Flutter's gesture arena prevents vertical
          // drag from being consumed by the PageView.
          physics: const BouncingScrollPhysics(),
          children: List.generate(
            _kTabs.length,
            (index) => _ProductTabContent(
              tabIndex: index,
              onRefresh: _onRefresh,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: _kBannerHeight,
      pinned: false,   // the AppBar itself is NOT pinned — it scrolls away
      floating: false, // does not re-appear until fully scrolled to top
      snap: false,
      backgroundColor: const Color(0xffE54B4B),
      elevation: innerBoxIsScrolled ? 2 : 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: _BannerContent(user: widget.user),
      ),
      // The forceElevated flag ensures a visual shadow when inner has scrolled
      forceElevated: innerBoxIsScrolled,
      actions: [
        // Profile button
        IconButton(
          icon: Icon(Icons.person_outline_rounded,
              color: Colors.white, size: 20.sp),
          onPressed: () {
            context.pushNamed(RoutePath.profilePage);
          },
        ),
        // Logout button
        IconButton(
          icon: Icon(Icons.logout_rounded,
              color: Colors.white, size: 20.sp),
          onPressed: () {
            context.read<AuthBloc>().add(LogoutEvent());
            context.go('/login');
          },
        ),
      ],
    );
  }
}

// ─── Banner content: user profile + search bar ────────────────────────────────

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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              // ── User profile row ────────────────────────────────────
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: Colors.white24,
                    child: Text(
                      user.firstName.isNotEmpty
                          ? user.firstName[0].toUpperCase()
                          : 'U',
                      style: interBold.copyWith(
                          fontSize: 16.sp, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${user.fullName}',
                        style: interSemiBold.copyWith(
                            fontSize: 14.sp, color: Colors.white),
                      ),
                      Text(
                        user.email,
                        style: interRegular.copyWith(
                            fontSize: 11.sp,
                            color: Colors.white.withValues(alpha: 0.8)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      Icon(Icons.notifications_outlined,
                          color: Colors.white, size: 24.sp),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 14.h),

              // ── Search bar ──────────────────────────────────────────
              Container(
                height: 42.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 12.w),
                    Icon(Icons.search_rounded,
                        color: Colors.grey, size: 20.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          hintStyle: interRegular.copyWith(
                              fontSize: 13.sp, color: Colors.grey),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: interRegular.copyWith(fontSize: 13.sp),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 4.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xffE54B4B),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(Icons.search,
                          color: Colors.white, size: 16.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sticky tab bar delegate ──────────────────────────────────────────────────
// SliverPersistentHeader requires a delegate to specify min/max extents.
// We use a fixed height equal to the tab bar height — no magic numbers,
// the tab bar measures itself.

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const _StickyTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => _kTabBarHeight; // collapsed = same as expanded

  @override
  double get maxExtent => _kTabBarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate old) => old.tabBar != tabBar;
}

// ─── Per-tab product content ──────────────────────────────────────────────────
// This is the INNER scrollable for each tab. NestedScrollView coordinates
// between the outer (header) scroll and this inner scroll automatically.
//
// AutomaticKeepAliveClientMixin ensures the tab content is NOT disposed when
// switching tabs, preserving scroll position and widget state.

class _ProductTabContent extends StatefulWidget {
  final int tabIndex;
  final Future<void> Function() onRefresh;

  const _ProductTabContent({
    required this.tabIndex,
    required this.onRefresh,
  });

  @override
  State<_ProductTabContent> createState() => _ProductTabContentState();
}

class _ProductTabContentState extends State<_ProductTabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin

    return BlocBuilder<ProductListingBloc, ProductListingState>(
      builder: (context, state) {
        if (state is ProductListingLoading) {
          return const CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }

        if (state is ProductListingError) {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                      Gap(12.h),
                      Text(state.message,
                          textAlign: TextAlign.center,
                          style: interRegular.copyWith(color: Colors.grey)),
                      Gap(12.h),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffE54B4B),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => context
                            .read<ProductListingBloc>()
                            .add(LoadAllProductsEvent()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        final products = state is ProductListingLoaded
            ? state.forTab(widget.tabIndex)
            : <Product>[];

        // ── INNER SCROLLABLE ──────────────────────────────────────────
        // RefreshIndicator is placed HERE (per-tab), not at the outer level.
        // Reason: NestedScrollView delivers overscroll notifications from
        // inner scrollables. Placing RefreshIndicator at the NestedScrollView
        // level would require fragile depth-based notification filtering.
        return RefreshIndicator(
          color: const Color(0xffE54B4B),
          onRefresh: widget.onRefresh,
          child: products.isEmpty && state is ProductListingLoaded
              ? CustomScrollView(
                  // PageStorageKey saves scroll offset when switching tabs
                  key: PageStorageKey<String>('tab_${widget.tabIndex}'),
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    const SliverFillRemaining(
                      child:
                          Center(child: Text('No products in this category')),
                    ),
                  ],
                )
              : CustomScrollView(
                  key: PageStorageKey<String>('tab_${widget.tabIndex}'),
                  // AlwaysScrollableScrollPhysics ensures pull-to-refresh
                  // works even when the list is shorter than the viewport.
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 12.h),
                      sliver: SliverGrid(
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.h,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => ProductCard(
                            product: products[index],
                          ),
                          childCount: products.length,
                        ),
                      ),
                    ),
                    // Bottom padding so last row isn't hidden behind bottom bar
                    SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                  ],
                ),
        );
      },
    );
  }
}
