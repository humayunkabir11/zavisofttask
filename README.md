# zavi_soft_task

A Flutter project demonstrating a Daraz-style product listing with a single-scroll architecture.

## Requirements Fulfilled

- Collapsible header (banner + search)
- Sticky TabBar
- Product tabs from FakeStore API categories
- Login + Profile screen integration
- Exactly ONE vertical scrollable feel
- Pull-to-refresh from any tab
- No scroll conflicts or jitter
- Swipe + Tap tab switching
- No scroll position reset on tab change

## How it works
## Horizontal swipe

Implemented with TabBarView inside a NestedScrollView.

Swipe gestures move between tabs, while vertical scroll goes to the main scroll.

## Vertical scroll ownership

NestedScrollView handles the vertical scroll.

Header (SliverAppBar) collapses as you scroll.

Tab content scrolls after the header collapses, giving one smooth scroll experience.

## Trade-offs / limitations

Pull-to-refresh is inside each tab to work correctly with multiple tabs.

Tabs with very different content lengths may slightly shift the header during fast tab changes. PageStorageKey is used to reduce this.

## Run Instructions

```bash
flutter run
```
