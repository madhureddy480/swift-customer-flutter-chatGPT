# Dr Swift Diagnostics — Customer Flutter App

Production-grade **iOS and Android** app for [Dr Swift Diagnostics](https://drswift.in).

Book at-home diagnostic tests, browse health profiles, and (in future phases) manage family reports and longitudinal health trends.

> **Status:** Phase 0–1 in progress — catalog UI wired to seed-data JSON fixtures; auth, cart, and reports APIs pending.

**Tagline:** *See More Than Numbers. See Your Health.*

---

## Table of Contents

- [Getting Started](#getting-started)
- [Catalog Data](#catalog-data)
- [Project Structure](#project-structure)
- [Run & Build](#run--build)
- [Architecture](#architecture)
- [Navigation](#navigation)
- [API Integration](#api-integration)
- [Design System](#design-system)
- [Testing](#testing)
- [Roadmap](#roadmap)
- [Related Repositories](#related-repositories)

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.3+ (`brew install --cask flutter`)
- CocoaPods for iOS (`brew install cocoapods`)
- Xcode (iOS) / Android Studio (Android SDK)

### Setup

```bash
cd swift_customer_flutter_chatGPT
./scripts/setup.sh
```

This fetches dependencies, generates platform folders if missing, and runs static analysis.

### Quick run

```bash
flutter run --dart-define=ENV=dev
```

---

## Catalog Data

The app no longer uses hardcoded mock catalog data. Tests, symptom categories, and health profiles are loaded from **JSON fixtures** generated from the seed CSV files you imported into DrSwift-CMS.

### Source files (repo root)

| CSV | Contents |
|-----|----------|
| `Test List-Table 1.csv` | 52 individual lab tests (codes, names, Telugu, symptoms) |
| `Category List-Table 1.csv` | 10 symptom categories → test mappings (Weakness, Fever, Sugar, …) |
| `Profiles-Table 1.csv` | 7 health profiles (DRS Diabetic, Check 72, Fever, …) |

### Generated fixtures (`assets/data/`)

| JSON file | Shape | Used for |
|-----------|-------|----------|
| `catalog.json` | `GET /api/v1/public/catalog` | All tests + profiles (`tests`, `promotions`, `featuredCollections`) |
| `categories.json` | App-specific | Symptom category list and test membership |
| `profiles.json` | App-specific | Health profile packages and included tests |

Regenerate after CSV edits:

```bash
python3 scripts/generate_catalog_json.py
```

### Data flow

```
Seed CSVs  →  scripts/generate_catalog_json.py  →  assets/data/*.json
                                                        ↓
                                              AssetCatalogRepository
                                                        ↓
                                              CatalogUiMapper → UI screens
```

### Switching to live CMS APIs

JSON fixtures mirror the [DrSwift-CMS](../DrSwift-CMS/) public catalog DTOs (`CatalogController`). To use HTTP instead of bundled assets:

```bash
flutter run --dart-define=USE_CATALOG_API=true --dart-define=ENV=dev
```

| Mode | Repository | Data source |
|------|------------|-------------|
| Default | `AssetCatalogRepository` | `assets/data/*.json` |
| `USE_CATALOG_API=true` | `ApiCatalogRepository` | `GET /api/v1/public/catalog` |

**Important:** CMS public endpoints use server-side Basic Auth. Do **not** embed CMS credentials in the mobile app — route catalog calls through a Customer BFF or secure proxy in production.

Placeholder prices in JSON are used because the CSVs do not include pricing. Live CMS/DB data will supply real `priceCents` when the API is wired.

---

## Project Structure

```
lib/
  app.dart, main.dart
  core/
    config/           # AppConfig, environment flavors
    constants/        # ApiPaths, AssetPaths
    network/          # Dio ApiClient, interceptors
    storage/          # Secure JWT storage
    theme/            # Colors, typography, spacing
    widgets/          # Design system (DsScaffold, DsCard, …)
    errors/
  features/
    onboarding/       # Splash + 3-page onboarding
    home/             # Tests tab home
    catalog/          # Categories, test list, test detail, JSON/API repository
    profiles/         # Health profile browse + booking flow (mock checkout)
    reports/          # Reports tab shell
    dashboard/        # Health tab (trend charts shell)
    profile/          # Account tab
    authentication/   # Login placeholder
  routing/            # GoRouter + 4-tab shell

assets/
  data/               # catalog.json, categories.json, profiles.json
  icons/              # SVG icons
  images/             # Logo
  onboarding/         # Onboarding illustrations

scripts/
  setup.sh
  generate_catalog_json.py

test/                 # Unit + widget tests
```

### Key catalog files

| Path | Role |
|------|------|
| `lib/features/catalog/data/models/catalog_models.dart` | CMS-aligned DTOs |
| `lib/features/catalog/data/repositories/catalog_repository.dart` | Asset + API repositories |
| `lib/features/catalog/data/catalog_providers.dart` | Riverpod providers |
| `lib/features/catalog/data/mappers/catalog_ui_mapper.dart` | DTO → screen models |
| `lib/features/catalog/presentation/catalog_route_loaders.dart` | Async route wrappers |

---

## Run & Build

```bash
# Development
flutter run --dart-define=ENV=dev

# Other environments
flutter run --dart-define=ENV=test
flutter run --dart-define=ENV=uat
flutter run --dart-define=ENV=prod

# Live catalog API (when BFF/CMS endpoint is configured)
flutter run --dart-define=ENV=dev --dart-define=USE_CATALOG_API=true

# Analyze & test
flutter analyze
flutter test
```

### Environment API base URLs

Configured in `lib/core/config/app_config.dart`:

| ENV | Base URL |
|-----|----------|
| `dev` / `test` | `https://test-api-customer.drswift.in` |
| `uat` | `https://uat-api-customer.drswift.in` |
| `prod` | `https://api.drswift.in` |

---

## Architecture

### Stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter 3.x, Dart 3 |
| State | Riverpod |
| Navigation | GoRouter |
| HTTP | Dio (JWT interceptors, retry) |
| Models | Freezed + json_serializable (core); hand-written catalog DTOs |
| Auth (planned) | Firebase → Customer BFF JWT exchange |
| Storage | flutter_secure_storage |
| Charts | fl_chart |
| Observability | Firebase Crashlytics, Analytics, FCM |

Feature-first layout: each feature owns `data/`, `presentation/` (and `domain/` when business logic grows).

### System context

```
┌──────────────┐     Firebase Auth      ┌──────────────┐
│  Flutter App │ ◄────────────────────► │   Firebase   │
│  (this repo) │     FCM / Crashlytics    └──────────────┘
└──────┬───────┘
       │ HTTPS + JWT (planned)
       ▼
┌──────────────┐     catalog            ┌──────────────┐
│ Customer BFF │ ◄────────────────────► │  DrSwift-CMS │
│ (planned)    │                          └──────────────┘
└──────┬───────┘
       ▼
┌──────────────┐
│   Supabase   │  swiftunit schema
└──────────────┘
```

**Rules:**
- Never query Supabase directly from the mobile app.
- Never embed CMS Basic Auth credentials in the app binary.
- Mobile uses `familyProfileId`; Swift SSN stays internal to backend only.

---

## Navigation

4-tab shell per `ui_ux.png`:

| Tab | Route | Status |
|-----|-------|--------|
| **Tests** | `/tests` | Home, categories, profiles, test detail — **seed JSON** |
| **Reports** | `/reports` | Shell UI |
| **Health** | `/health` | Trend dashboard shell |
| **Account** | `/account` | Shell UI |

### Implemented catalog routes

| Route | Screen |
|-------|--------|
| `/tests` | Tests home (profiles + category preview) |
| `/categories` | All symptom categories |
| `/categories/:slug` | Tests in category |
| `/tests/:slug` | Test detail bottom sheet |
| `/profiles` | Health profiles grid |
| `/profiles/:slug` | Profile detail + booking flow |

---

## API Integration

### Live today (DrSwift-CMS)

| Endpoint | Purpose |
|----------|---------|
| `GET /api/v1/public/catalog` | Full catalog bundle |
| `GET /api/v1/public/catalog/tests/{slug}` | Single test detail |
| `GET /api/v1/public/hero-carousel?slug=` | Promo carousel |
| `GET /api/v1/public/health` | Health check |

### Planned (Customer BFF skeleton)

| Domain | Endpoints |
|--------|-------------|
| Auth | `POST /api/auth/firebase/exchange` |
| Account | `GET / PATCH /api/me` |
| Cart / Checkout | `/api/cart`, `/api/checkout/*` |
| Orders | `/api/orders` |
| Family | `/api/family` |
| Reports | `/api/reports`, `/api/reports/summary` |

See [`swift-customer-portal-chatGPT`](../swift-customer-portal-chatGPT/) for API skeleton contracts and [`plan.txt`](./plan.txt) for the full engineering spec.

---

## Design System

| Token | Value |
|-------|-------|
| Primary purple | `#583A8E` / `#662FC1` |
| Icons | `assets/icons/*.svg` |
| Logo | `assets/images/logo.png` |

Shared widgets live in `lib/core/widgets/` — `DsScaffold`, `DsPrimaryButton`, `DsStatusChip`, `DsEmptyState`, `DsErrorState`, etc.

Brand and UX reference docs: [`swift-customer-portal-chatGPT`](../swift-customer-portal-chatGPT/) (`01-Brand.md`, `02-DESIGN-SYSTEM.md`, `04-MOBILE-APP-UX.md`).

UI mockup: [`ui_ux.png`](./ui_ux.png)

---

## Testing

```bash
flutter test
```

| Test file | Covers |
|-----------|--------|
| `test/catalog_flow_test.dart` | Seed JSON load, category UI |
| `test/core/app_theme_test.dart` | Theme tokens |
| `test/core/error_mapper_test.dart` | Dio error mapping |
| `test/widget_test.dart` | App bootstrap |

---

## Roadmap

| Phase | Focus | Status |
|-------|-------|--------|
| **0** | Scaffold, theme, routing, design system | Done |
| **1** | Catalog UI + seed JSON fixtures | **In progress** |
| **1b** | Wire catalog to CMS/BFF API | Next |
| **2** | Firebase auth + JWT, cart, checkout | Planned |
| **3** | Reports, family switcher, health trends | Planned |
| **4** | FCM, polish, store release | Planned |

Full phased plan: [`plan.txt`](./plan.txt)

### v1 definition of done (summary)

- [x] 4-tab shell matching mockup structure
- [x] Catalog browse from real seed data (JSON)
- [ ] Firebase OTP + Google + Apple sign-in
- [ ] JWT auth with secure storage
- [ ] Cart + checkout + orders via Customer BFF
- [ ] Reports with family switcher and PDF download
- [ ] Health dashboard from report trend APIs
- [ ] No Supabase or CMS credentials in the app binary

---

## Related Repositories

| Repository | Role |
|------------|------|
| [DrSwift-CMS](../DrSwift-CMS/) | Catalog CMS + `GET /api/v1/public/*` |
| [swift-customer-portal-chatGPT](../swift-customer-portal-chatGPT/) | Patient web portal + Customer BFF skeleton |
| [DrSwift-CMS/datamodel.sql](../DrSwift-CMS/datamodel.sql) | Supabase `swiftunit` schema |

---

## Repository Assets

| Path | Purpose |
|------|---------|
| [`plan.txt`](./plan.txt) | Full engineering specification |
| [`ui_ux.png`](./ui_ux.png) | Primary UI mockup (11 screens) |
| `Test List-Table 1.csv` | Seed test catalog |
| `Category List-Table 1.csv` | Seed symptom categories |
| `Profiles-Table 1.csv` | Seed health profiles |
| `assets/data/` | Generated catalog JSON fixtures |
| `assets/icons/` | App SVG icons |
