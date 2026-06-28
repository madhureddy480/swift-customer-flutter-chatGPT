# Dr Swift Diagnostics — Customer Flutter App

Production-grade iOS and Android app for **Dr Swift Diagnostics** ([drswift.in](https://drswift.in)).

Book at-home diagnostic tests, manage family health profiles, and view longitudinal reports with trends and insights.

> **Status:** Phase 0 scaffold complete — run `./scripts/setup.sh` after installing Flutter SDK.

---

## Table of Contents

- [Product Vision](#product-vision)
- [Technology Stack](#technology-stack)
- [Repository Assets](#repository-assets)
- [Platform Context](#platform-context)
- [Architecture](#architecture)
- [Navigation & Screens](#navigation--screens)
- [Feature Modules](#feature-modules)
- [API Contract](#api-contract)
- [Design System](#design-system)
- [Implementation Phases](#implementation-phases)
- [Project Bootstrap Checklist](#project-bootstrap-checklist)
- [Testing Strategy](#testing-strategy)
- [Open Decisions](#open-decisions)
- [Definition of Done (v1)](#definition-of-done-v1)
- [Related Repositories](#related-repositories)

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.3+ — installed via `brew install --cask flutter`
- CocoaPods (iOS) — `brew install cocoapods`
- Xcode (iOS builds) — install from App Store, then run `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
- Android Studio (Android builds) — for Android SDK and emulator

### Setup

```bash
cd swift_customer_flutter_chatGPT
./scripts/setup.sh
```

The setup script generates `android/` and `ios/` folders (if missing), fetches dependencies, and runs static analysis.

### Run

```bash
# Development (test API)
flutter run --dart-define=ENV=dev

# Other environments
flutter run --dart-define=ENV=test
flutter run --dart-define=ENV=uat
flutter run --dart-define=ENV=prod
```

### Project structure (implemented)

```
lib/
  app.dart, main.dart
  core/          # config, network, storage, theme, widgets, errors
  features/
    onboarding/  # splash + 3-page onboarding
    home/        # Tests tab (mock catalog UI)
    reports/     # Reports tab (guest + sample preview)
    dashboard/   # Health tab (trend charts)
    profile/     # Account tab
    authentication/  # Login screen shell
  routing/       # GoRouter + 4-tab shell
test/            # unit tests
```

---

**Tagline:** *See More Than Numbers. See Your Health.*

Dr Swift is a **longitudinal health history platform**, not just a test-ordering app. The differentiator is family-scoped reports, biomarker trends, and actionable insights over time.

| Principle | Detail |
|-----------|--------|
| Core asset | Health history per family member (Swift SSN internally — never exposed to mobile) |
| Collection model | Home sample collection only — phlebotomist visits the customer |
| Reports | Permanent access; English and Telugu PDFs |
| Family | One account manages multiple family members; insights are never mixed across profiles |
| UX philosophy | Apple-grade simplicity — one primary action per screen, progressive disclosure |

---

## Technology Stack

### Mobile (this repo)

| Layer | Choice |
|-------|--------|
| Framework | Flutter 3.x (latest stable), Dart 3 |
| State management | Riverpod |
| Navigation | GoRouter |
| Models | Freezed + json_serializable |
| HTTP | Dio (interceptors for JWT, retry) |
| Auth | Firebase (OTP, Google, Apple) → backend JWT exchange |
| Secure storage | flutter_secure_storage |
| Charts | fl_chart |
| Images | cached_network_image, flutter_svg |
| Observability | Firebase Crashlytics, Firebase Analytics |
| Notifications | Firebase Cloud Messaging |

**Not used:** Provider, GetX, BLoC, MVC, singleton-heavy architecture, direct Supabase access.

### Backend & Infrastructure

| Layer | Choice |
|-------|--------|
| API | Java, Spring Boot |
| Hosting | DigitalOcean, nginx, Cloudflare |
| Database | Supabase PostgreSQL (`swiftunit` schema) |
| CMS / Catalog | [DrSwift-CMS](../DrSwift-CMS/) |
| Auth | Firebase ID token verification → JWT |

---

## Repository Assets

| Path | Purpose |
|------|---------|
| [`plan.txt`](./plan.txt) | Full engineering specification (architecture, modules, code quality) |
| [`ui_ux.png`](./ui_ux.png) | Primary UI/UX mockup (11 screens) |
| [`public/assets/icons/`](./public/assets/icons/) | Curated SVG icons for the app |
| [`svg files/`](./svg%20files/) | Source SVG asset library |

Brand, UX, and data-model docs live in [`swift-customer-portal-chatGPT`](../swift-customer-portal-chatGPT/):

- `01-Brand.md` — colors, personality, tagline
- `02-DESIGN-SYSTEM.md` — cards, typography, buttons
- `04-MOBILE-APP-UX.md` — mobile UX philosophy (note: tab count differs from mockup — see [Navigation](#navigation--screens))
- `05-REPORTS-AND-INSIGHTS.md` — Reports tab behavior (highest-priority module)
- `06-BUSINESS-RULES.md` — family, orders, reports rules
- `07-DATA-MODEL.md` — Swift SSN, ownership model
- `APPLICATION-SKELETON.md` — planned backend API contracts

---

## Platform Context

### What exists today

```
┌─────────────────────────────────────────────────────────────┐
│  DEPLOYED                                                   │
│  • DrSwift-CMS — catalog API (read-only, Basic Auth)        │
│    GET /api/v1/public/catalog, /hero-carousel, /tests/{slug}│
│  • Channel Partner API — *-api.drswift.in (partner app)     │
│  • Reports service — *-reports.drswift.in                   │
│  • Patient web portal — unit/test/uat.drswift.in            │
├─────────────────────────────────────────────────────────────┤
│  PLANNED (skeleton only)                                    │
│  • Customer BFF — auth, cart, orders, family, reports       │
│  • This Flutter app                                         │
└─────────────────────────────────────────────────────────────┘
```

### Capability matrix

| Capability | Status | Location |
|------------|--------|----------|
| Test catalog (100+ tests, promos) | **Live** | DrSwift-CMS `/api/v1/public/*` |
| Firebase → JWT auth | **Not built** | `POST /api/auth/firebase/exchange` (skeleton) |
| Cart, checkout, orders | **Not built** | `swift-customer-portal-chatGPT` API skeleton |
| Family profiles | **Not built** | Same skeleton |
| Reports & health summary | **Not built** | DB tables exist; API skeleton defined |
| Addresses | **Not built** | Domain entity only — API TBD |
| Push notifications | **Not built** | `device_push_tokens` table exists |

**Critical rule:** The mobile app must **never** embed CMS Basic Auth credentials or query Supabase directly. All data flows through a **Customer BFF** with JWT auth.

---

## Architecture

### System overview

```
┌──────────────┐     Firebase Auth      ┌──────────────┐
│  Flutter App │ ◄────────────────────► │   Firebase   │
│  (this repo) │     FCM / Crashlytics    └──────────────┘
└──────┬───────┘
       │ HTTPS + JWT
       ▼
┌──────────────┐     catalog proxy      ┌──────────────┐
│ Customer BFF │ ◄────────────────────► │  DrSwift-CMS │
│ (Spring Boot)│                          └──────────────┘
└──────┬───────┘
       │
       ▼
┌──────────────┐     reports (optional)  ┌──────────────┐
│   Supabase   │ ◄────────────────────► │ Reports Svc  │
│  swiftunit   │                          └──────────────┘
└──────────────┘
```

### Flutter folder structure

Feature-first Clean Architecture — separate `data`, `domain`, and `presentation` per feature:

```
lib/
  core/
    config/       # flavors, env, API base URL
    constants/
    errors/
    network/      # ApiClient, interceptors
    services/
    storage/      # secure JWT storage
    theme/        # Material 3, light/dark
    utils/
    widgets/      # shared design-system components
  features/
    authentication/
    onboarding/
    home/
    categories/
    tests/
    cart/
    booking/
    reports/
    dashboard/    # Health tab
    profile/
    family/
    notifications/
    orders/
    addresses/
  routing/        # GoRouter + auth guards
  main.dart
```

### Auth flow

1. User signs in via Firebase (OTP / Google / Apple)
2. App sends Firebase ID token to `POST /api/auth/firebase/exchange`
3. Backend returns `accessToken`, `refreshToken`, and `account`
4. Tokens stored in `flutter_secure_storage`
5. Dio `AuthInterceptor` attaches JWT; handles automatic refresh
6. Phone verification required before first order

---

## Navigation & Screens

### Bottom navigation (follow `ui_ux.png`)

| Tab | Purpose |
|-----|---------|
| **Tests** | Discovery — search, categories, health profiles, test details, cart entry |
| **Reports** | Report list, biomarker cards, insights, in-header family switcher |
| **Health** | Longitudinal trend dashboard (fl_chart) |
| **Account** | Auth, profile, family, orders, addresses, notifications, settings |

> **Note:** `04-MOBILE-APP-UX.md` describes 5 tabs (Home, Tests, Packages, Reports, Account). The **mockup and `plan.txt` use 4 tabs** — packages/health profiles live inside the Tests tab.

### Screen map (mockup → feature)

| Mockup | Screen | Module | Auth |
|--------|--------|--------|------|
| 1A | Splash | `onboarding` | No |
| 1B–1C | Onboarding (3 pages) | `onboarding` | No |
| 2 | Tests home | `home`, `categories` | Browse: No |
| 2B | All categories | `categories` | No |
| 2C | Tests in category | `tests` | No |
| 2A | Health profile detail | `tests` | No |
| 2D | Test detail bottom sheet | `tests` | No |
| 3 | Reports | `reports` | Yes |
| 4 | Health dashboard | `dashboard` | Yes |
| 5 | Account / Login | `authentication`, `profile` | Mixed |

Additional screens (not in mockup): Cart, Checkout, Address picker, Slot selection, Order confirmation, Order history, Family CRUD, Notification inbox, PDF viewer, Settings, Support.

---

## Feature Modules

### Authentication & Onboarding
- Splash with JWT check
- 3-page value-prop onboarding
- Phone OTP, Google Sign-In, Apple Sign-In (iOS)
- Login / Sign up toggle
- Guest catalog browse; login gate on cart

### Tests (Discovery & Booking)
- Search with debounce
- Category grid and full category list
- Health profile (package) horizontal scroll + detail
- Test detail bottom sheet: reference range bar, prep instructions, "often booked with"
- Add to cart (mixed tests + packages)

### Cart & Booking
- Server-synced cart with per-line family member
- Address management
- Slot selection → quote → place order
- Payment placeholder in v1 (Razorpay/PhonePe in post-launch phase)

### Reports (highest priority)
- Family switcher always in header — never navigate away to switch
- States: no reports / one report / multiple reports
- Biomarker cards with status colors (green / orange / red)
- Health summary, parameter detail, PDF download (EN / TE)
- Historical comparison (requires 2+ reports)

### Health Dashboard
- Per-metric mini line charts, current value, trend direction
- Data from reports summary and parameter trend APIs

### Account
- Profile, family members, orders, addresses, notifications, settings, support, logout

---

## API Contract

Mobile-facing contract (from `swift-customer-portal-chatGPT` skeleton). Version as `/api/v1/...` when implemented.

### Recommended base URLs

| Environment | Customer API |
|-------------|--------------|
| Unit | `https://unit-api-customer.drswift.in` (or `https://unit.drswift.in/api`) |
| Test | `https://test-api-customer.drswift.in` |
| UAT | `https://uat-api-customer.drswift.in` |
| Production | `https://api.drswift.in` |

### Endpoints

| Domain | Methods |
|--------|---------|
| **Auth** | `POST /api/auth/firebase/exchange` |
| **Account** | `GET / PATCH /api/me` |
| **Catalog** | `GET /api/catalog/categories`, `/tests`, `/tests/{id}`, `/packages`, `/packages/{slug}` |
| **Cart** | `GET /api/cart`, `POST /api/cart/items`, `DELETE /api/cart/items/{id}` |
| **Checkout** | `POST /api/checkout/quote`, `POST /api/checkout/place-order` |
| **Orders** | `GET /api/orders`, `GET /api/orders/{id}`, `POST /api/orders/{id}/cancel` |
| **Family** | `GET / POST /api/family`, `GET / PATCH /api/family/{id}` |
| **Reports** | `GET /api/reports?familyProfileId=`, `/summary`, `/parameters/{id}/trend` |
| **Addresses** | `GET / POST / PATCH / DELETE /api/addresses` *(TBD)* |
| **Notifications** | `POST /api/devices/push-token`, `GET /api/notifications` *(TBD)* |

### Catalog ID reconciliation

CMS returns `Long` IDs and slugs with `priceCents`. Customer skeleton uses `UUID` and `priceMinor`. The Customer BFF needs an **adapter layer** — recommend slugs for URLs in v1.

---

## Design System

| Token | Value |
|-------|-------|
| Primary purple | `#583A8E` — `RGB(88, 58, 142)` |
| Background | White (light mode primary) |
| Card radius | 24px |
| Card border | `1px solid rgba(88, 58, 142, 0.10)` |
| Status — normal | Green |
| Status — borderline | Orange |
| Status — low / high / critical | Red |
| Icons | Custom SVGs in `public/assets/icons/` |

### Shared widgets to build (`core/widgets/`)

`DsScaffold`, `DsCard`, `DsPrimaryButton`, `DsOutlineButton`, `DsStatusChip`, `DsReferenceRangeBar`, `DsSkeleton`, `DsEmptyState`, `DsErrorState`, `DsOfflineBanner`, `DsTestListTile`, `DsCategoryTile`, `DsHealthProfileCard`, `DsBiomarkerCard`, `DsTrendSparkline`, `DsFamilyProfileSwitcher`, `DsBottomSheet`

Material 3, light + dark mode, accessibility labels, skeleton loaders, pull-to-refresh, proper empty/error/offline states.

---

## Implementation Phases

### Phase 0 — Foundation (Weeks 1–2)

| Backend | Mobile |
|---------|--------|
| Customer BFF: auth exchange + JWT | `flutter create`, folder structure, flavors |
| CMS catalog adapter | Design system + core widgets |
| OpenAPI spec, nginx route | Firebase project setup |
| Address + push-token contracts | Asset pipeline |

**Exit:** Auth exchange works E2E; catalog returns data; app launches with themed shell.

### Phase 1 — Auth & Catalog UI (Weeks 3–5)

| Backend | Mobile |
|---------|--------|
| Firebase Admin token verification | Splash, onboarding, login |
| Catalog endpoints with search | Tests tab: home, categories, lists, detail sheet |
| Refresh token endpoint | GoRouter + auth guards, guest browse |

**Exit:** User can sign in and browse full catalog matching mockup.

### Phase 2 — Cart & Booking (Weeks 6–8)

| Backend | Mobile |
|---------|--------|
| Cart, family, address, checkout, orders APIs | Cart, family CRUD, checkout flow |
| Phone verification gate | Order history |

**Exit:** End-to-end order placement (payment placeholder).

### Phase 3 — Reports & Health (Weeks 9–11)

| Backend | Mobile |
|---------|--------|
| Reports list, summary, trends, PDF URLs | Reports tab (all states), family switcher |
| Insights (rule-based v1) | Health tab charts, parameter detail |

**Exit:** Reports, trends, and insights per family member; PDF download works.

### Phase 4 — Polish & Release (Weeks 12–14)

| Backend | Mobile |
|---------|--------|
| FCM push triggers | FCM registration, notification inbox |
| Prod deployment | Dark mode, a11y, offline, tests, store submission |

**Exit:** TestFlight + Play internal track; crash-free > 99%.

### Phase 5 — Post-launch

Razorpay/PhonePe payments, coupons, doctor sharing, referrals, Telugu UI localization.

---

## Project Bootstrap Checklist

When implementation begins:

1. `flutter create` project in this directory
2. Add dependencies: `flutter_riverpod`, `go_router`, `freezed_annotation`, `json_annotation`, `dio`, `firebase_core`, `firebase_auth`, `firebase_messaging`, `firebase_crashlytics`, `firebase_analytics`, `google_sign_in`, `sign_in_with_apple`, `flutter_secure_storage`, `cached_network_image`, `flutter_svg`, `fl_chart`, `intl`, `permission_handler`, `share_plus`, `connectivity_plus`
3. Dev deps: `build_runner`, `freezed`, `json_serializable`, `mocktail`, `flutter_lints`
4. Flavors: `dev`, `test`, `uat`, `prod` with per-env `API_BASE_URL`
5. Copy icons from `public/assets/icons/`; logo from `../swift-customer-portal-chatGPT/logo500x500.png`
6. Build core layer first: `AppConfig`, `ApiClient`, interceptors, `AppTheme`, `AppRouter`
7. CI: `flutter analyze`, `flutter test`, format check on PR

---

## Testing Strategy

| Layer | Scope |
|-------|-------|
| **Unit** | DTO mappers, reference-range status logic, cart totals, JWT expiry |
| **Widget** | Biomarker card, reference range bar, login form, family switcher |
| **Integration** | Auth flow, catalog fetch, cart add/remove |
| **Manual QA** | Guest browse, OTP/Google/Apple, mixed cart, family switch, offline, dark mode |

Seed Supabase with sample reports for 2 family members and 3+ report dates before Phase 3.

---

## Open Decisions

| # | Topic | Recommendation |
|---|-------|----------------|
| 1 | Customer API hosting | New BFF service (not extend CMS admin) |
| 2 | Catalog IDs | Slugs for URLs in v1; UUID when account DB is live |
| 3 | Reports service | BFF aggregates for mobile; separate service for ingestion |
| 4 | Payment | Razorpay / PhonePe (India market) |
| 5 | Tab count | 4 tabs per `ui_ux.png` |
| 6 | Health profiles | Map CMS `testType` bundles → `PackageResponse` |
| 7 | Swift SSN | Internal only; mobile uses `familyProfileId` |

---

## Definition of Done (v1)

- [ ] 4-tab app matches `ui_ux.png` for all designed screens
- [ ] Firebase OTP + Google + Apple on iOS and Android
- [ ] JWT auth with secure storage and automatic refresh
- [ ] Full catalog browse (categories, tests, health profiles, search)
- [ ] Cart + checkout + order history (payment placeholder OK)
- [ ] Family member management
- [ ] Reports with family switcher, biomarker status, PDF download
- [ ] Health dashboard with trend charts
- [ ] Push notifications for order status
- [ ] Dark mode, accessibility, skeleton/empty/error/offline states
- [ ] Crashlytics + Analytics
- [ ] No Supabase or CMS credentials in the mobile binary
- [ ] TestFlight and Play Console internal track

---

## Related Repositories

| Repo | Role |
|------|------|
| [DrSwift-CMS](../DrSwift-CMS/) | Catalog content management + read-only public catalog API |
| [swift-customer-portal-chatGPT](../swift-customer-portal-chatGPT/) | Patient web portal + customer BFF API skeleton |
| [DrSwift-ChannelPartner-Backend](../DrSwift-ChannelPartner-Backend/) | Channel partner mobile app API (separate product) |
| [DrSwift-CMS/datamodel.sql](../DrSwift-CMS/datamodel.sql) | Supabase `swiftunit` schema |

---

## Immediate Next Steps

1. Confirm 4-tab navigation and Customer API hostname
2. Implement Customer BFF — auth + catalog adapter first (`swift-customer-portal-chatGPT`)
3. Publish OpenAPI 3.0 from skeleton interfaces
4. Create Firebase project (iOS bundle ID + Android application ID)
5. Bootstrap Flutter project (Phase 0 checklist)
6. Seed test reports in Supabase for Reports/Health UI development
