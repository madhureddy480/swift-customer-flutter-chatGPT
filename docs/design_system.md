# Design system — Dr Swift customer app

Composable UI lives in `lib/core/theme/` and `lib/core/widgets/ds_*.dart`. Feature tabs **compose** these primitives — never fork colors, spacing, or list patterns per tab.

## Theme

| Token | Location | Notes |
|-------|----------|-------|
| Colors | `lib/core/theme/app_colors.dart` | Brand purple, ink text, dividers |
| Spacing | `lib/core/theme/app_spacing.dart` | Screen padding, radii |
| Typography | `lib/core/theme/app_typography.dart` | Material text theme |
| Theme | `lib/core/theme/app_theme.dart` | `ThemeMode.light` only (UI is light-first) |

## Shell widgets

| Widget | File | Use for |
|--------|------|---------|
| `DsTabHeader` / `DsTabScrollView` | `ds_tab_header.dart` | Tab title, logo collapse, scroll shell |
| `DsScaffold` | `ds_scaffold.dart` | Page scaffold wrapper |
| `DsGlassCard` | `ds_glass_card.dart` | Reports accordions, glass panels |
| `DsPrimaryButton` | `ds_buttons.dart` | CTAs |

## Default list pattern — `DsCategoryStyleList` ★

**Use this for any stacked row list on a tab** (Tests categories, Health metrics, future Reports/Account rows).

### Spec

| Property | Value |
|----------|-------|
| Container | White · `14px` radius · `1px` `AppColors.divider` border |
| Row height | **58px** (`11px` vertical padding + `36px` icon) |
| Row padding | `16px` horizontal · `11px` vertical |
| Leading icon | `36px` circle, white glyph, status/category color fill |
| Divider | `1px`, indent **64px** (aligns with text after icon) |
| Title | `#071B3A` · `13px` · `w700` |
| Subtitle / meta | `#667085` · `10.5px` · `w500` |
| Trailing chevron | `#8B95A7` · `21px` (navigation rows) |

### Widgets

```dart
import 'package:dr_swift_diagnostics/core/widgets/ds_category_style_list.dart';

// Section title + list (Health member blocks, future tab sections)
DsCategoryStyleListSection(
  title: 'My Health',
  children: [/* rows */],
);

// List only (Tests categories — title rendered separately)
DsCategoryStyleList(children: [/* rows */]);

// Single row
DsCategoryStyleListRow(
  leading: DsCategoryStyleListLeadingIcon(color: ..., icon: ...),
  title: Text('HbA1c', style: DsCategoryStyleListTypography.title),
  subtitle: Text('Healthy range 5.7 – 6.4', style: DsCategoryStyleListTypography.subtitle),
  trailing: /* value, chevron, etc. */,
  onTap: () {}, // optional
);
```

### Metrics & typography tokens

- `DsCategoryStyleListMetrics` — padding, icon size, row height, divider indent
- `DsCategoryStyleListTypography` — title, subtitle, trailing text styles

### Current adopters

- **Tests** — `CategoryListTile` in `catalog_widgets.dart`
- **Health** — `HealthMetricTrendCard` in `health_metric_trend_card.dart`

### When NOT to use

- **Glass accordions** (Reports test-date panels) → `DsGlassCard`
- **Full-width promo / CTA cards** → `DsCard`, `DsPrimaryButton`
- **Data tables** (Reports results grid) → dedicated table widget

### Legacy

`DsCategoryTile` (`ds_category_tile.dart`) — older card-per-item pattern. **Do not use for new tab lists**; prefer `DsCategoryStyleList`.
