# App Session Flows — Architecture (Review Draft)

> **Status:** Approved design decisions (2026-06-29). Reorganize incrementally per migration plan.
>
> **Active sprint:** Guest (G1) flows only — all tab work targets `*_tab_guest_screen.dart` until further notice.
>
> **Current milestone:** Session layer + tab variant structure in place. Health **G1 guest** flow complete.

---

## Problem

The app has **one shell** (4 tabs: Tests, Reports, Health, Account) but **many user states**. Each tab can render different content per state. We must avoid:

1. Breaking layout when adding a new scenario
2. Drifting colors / typography away from the design system
3. Duplicating theme tokens per screen
4. Tangled `if (loggedIn)` logic inside every widget

---

## Core idea: orthogonal axes + per-member lab state

Account-level flags plus **per-family-member** lab status:

| Axis | Scope | Values | Meaning |
|------|-------|--------|---------|
| **Auth** | account | `guest` · `authenticated` | JWT present or browsing as guest |
| **Family** | account | `none` · `members` | No profiles · ≥1 family member on account |
| **Phone** | account | `unverified` · `verified` | One OTP verification per **account** (gates checkout) |
| **Lab data** | **each member** | `none` · `pending` · `available` | No reports · sample processing · results ready |

```dart
// lib/features/session/domain/user_session_context.dart
enum SessionAuth { guest, authenticated }
enum FamilyState { none, members }
enum PhoneVerificationState { unverified, verified }
enum MemberLabDataState { none, pending, available }

class FamilyMemberSession {
  const FamilyMemberSession({
    required this.id,
    required this.displayName, // e.g. "Me", "Mom", "Dad"
    required this.labData,
    this.phoneNumber, // optional — account holder can add per member
  });

  final String id;
  final String displayName;
  final MemberLabDataState labData;
  final String? phoneNumber;
}

class UserSessionContext {
  const UserSessionContext({
    required this.auth,
    required this.family,
    required this.accountPhoneVerified,
    required this.members,
  });

  final SessionAuth auth;
  final FamilyState family;
  final bool accountPhoneVerified;
  final List<FamilyMemberSession> members;

  bool get isGuest => auth == SessionAuth.guest;
  bool get isAuthenticated => auth == SessionAuth.authenticated;
  bool get canCheckout => isAuthenticated && accountPhoneVerified;

  bool get anyMemberPending =>
      members.any((m) => m.labData == MemberLabDataState.pending);
  bool get anyMemberHasResults =>
      members.any((m) => m.labData == MemberLabDataState.available);
  bool get allMembersEmpty =>
      members.every((m) => m.labData == MemberLabDataState.none);
}
```

A single Riverpod provider resolves this from auth token, family API, orders API, and local cache.

### Product decisions (locked)

1. **Guest Health & Reports** — always **whole-family, multi-user** sample (e.g. My Health / Mom / Dad). Never a single-user guest sample.
2. **Pending lab results** — **one flag per family member**, not account-wide. UI shows pending state per member (badge, section, or switcher row).
3. **Phone verification** — **once per account** (family account phone). Sufficient for checkout. Optional: add phone numbers to individual family members later (member `phoneNumber` field above).

---

## Scenario matrix (your list + gaps)

Same tabs everywhere; **tab body** switches by scenario.

| ID | Scenario | Auth | Lab | Family | Typical tab behavior |
|----|----------|------|-----|--------|----------------------|
| **G1** | Guest (non-logged-in) | guest | sample (multi-member)* | sample* | Multi-user sample Health/Reports (My Health / Mom / Dad); login CTAs on Account |
| **A1** | Logged in, no data | auth | all `none` | none | Empty states; book-test prompts (self only) |
| **A2** | Logged in, no data, has family | auth | all `none` | members | Empty per member section |
| **A3** | Pending (self), no family | auth | self `pending` | none | Pending card for self; no switcher |
| **A4** | Pending (mixed), has family | auth | per-member `pending` | members | Pending badge per member; some may also have results |
| **A5** | Results (self), no family | auth | self `available` | none | Full reports/health for self only |
| **A6** | Results, has family | auth | per-member mix | members | Family sections/switcher; each member’s own lab state |

\* Guest always uses **multi-member marketing sample** across Health and Reports — same family cast, not real PHI.

**Per-member mixes (authenticated):** At runtime each `FamilyMemberSession.labData` is independent. Example: Mom `pending`, Dad `available`, Me `none` — Health tab renders three sections with appropriate empty/pending/results content per section.

---

## Folder layout (per feature tab)

```
lib/
  core/                          # NEVER scenario-specific
    theme/                       # AppColors, AppTypography, AppSpacing, AppTheme
    widgets/                     # DsScaffold, DsCard, DsButtons, …
    config/
    network/
  features/
    session/                       # UserSessionContext, scenario resolvers, providers
    health/                        # Health tab variants + widgets + data
    reports/                       # Reports tab variants
    tests/                         # Tests tab variants (guest catalog browse)
    account/                       # Account tab variants
    catalog/                       # Catalog domain (shared by Tests tab)
    profiles/                      # Health profile booking flow
    authentication/                # Login, auth providers
    onboarding/                    # Splash + onboarding
  routing/
    app_router.dart                # routes UNCHANGED; still /health, /reports, …
    app_shell.dart                 # 4 tabs UNCHANGED
```

### Naming convention

| Pattern | Example | Role |
|---------|---------|------|
| `{tab}_tab_screen.dart` | `health_tab_screen.dart` | Entry point; delegates to variant |
| `{tab}_tab_{scenario}_screen.dart` | `health_tab_guest_screen.dart` | One scenario’s layout |
| `{tab}_*.dart` in `widgets/` | `health_metric_trend_card.dart` | Reusable; scenario-agnostic |
| `{tab}_*_data.dart` in `data/` | `health_sample_data.dart` | Mock/API view models per scenario |

**Rename map (Health — when approved):**

| Current | Proposed |
|---------|----------|
| `health_dashboard_screen.dart` | `variants/health_tab_guest_screen.dart` |
| `health_care_carousel.dart` | `widgets/health_care_carousel.dart` (move only) |

---

## Tab entry pattern (thin router)

```dart
// health_tab_screen.dart
class HealthTabScreen extends ConsumerWidget {
  const HealthTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(userSessionProvider);
    return switch (resolveHealthScenario(session)) {
      HealthScenario.guestFamilySample => const HealthTabGuestScreen(),
      HealthScenario.empty => const HealthTabEmptyScreen(),
      HealthScenario.mixed => const HealthTabMixedScreen(),
      HealthScenario.resultsSelf => const HealthTabResultsSelfScreen(),
      HealthScenario.resultsFamily => const HealthTabResultsFamilyScreen(),
    };
  }
}
```

`app_router.dart` imports only `HealthTabScreen`, never individual variants.

---

## Scenario resolver (per tab)

Each tab defines a small enum + pure function — **no UI**:

```dart
enum HealthScenario { guestFamilySample, empty, mixed, resultsSelf, resultsFamily }

HealthScenario resolveHealthScenario(UserSessionContext s) {
  if (s.isGuest) return HealthScenario.guestFamilySample;
  if (s.family == FamilyState.none) {
    final self = s.members.firstOrNull;
    if (self?.labData == MemberLabDataState.none) return HealthScenario.empty;
    if (self?.labData == MemberLabDataState.pending) return HealthScenario.mixed;
    return HealthScenario.resultsSelf;
  }
  if (s.allMembersEmpty) return HealthScenario.empty;
  if (s.anyMemberPending || _hasMixedMemberStates(s)) return HealthScenario.mixed;
  return HealthScenario.resultsFamily;
}

bool _hasMixedMemberStates(UserSessionContext s) {
  final states = s.members.map((m) => m.labData).toSet();
  return states.length > 1; // e.g. pending + available, or none + available
}
```

`mixed` covers per-member pending alongside empty or available results (the common real-world case).

**Checkout gate (Tests tab):** if `!s.canCheckout`, show phone-verify prompt — account-level, one verification covers the family account. Member-level phones are optional contact fields only.

---

## What stays frozen (design contract)

| Layer | Rule |
|-------|------|
| `core/theme/*` | Single source for colors, type scale, radii |
| `core/widgets/ds_*.dart` | All cards, chips, buttons, scaffolds |
| `AppShell` + `RoutePaths` | Tab labels, icons, paths never fork per scenario |
| Variants | **Compose** `Ds*` widgets; no ad-hoc `Color(0xFF…)` except in theme |
| Data | Variants receive `ViewModel` / `Content` objects; no API calls inside leaf widgets |

Guest Health tab today is the template for **G1**: carousel + multi-member sections (My Health / Mom / Dad) using shared tokens (`AppColors`, `AppSpacing`). Guest Reports must follow the same multi-member pattern.

---

## Migration plan (incremental)

1. **Phase A** — Add `session` feature + providers (stub flags; guest = today’s behavior).
2. **Phase B** — Health tab only: introduce `health_tab_screen.dart` + move current screen to `health_tab_guest_screen.dart`.
3. **Phase C** — Extract shared widgets from guest screen (`health_metric_trend_card.dart`, etc.).
4. **Phase D** — Add empty/pending/family variants one at a time with dedicated `data/` mocks.
5. **Phase E** — Repeat pattern for Reports, Account, Tests (guest browse already partially exists).

No big-bang rename. Router diff stays minimal each step.

---

## Testing strategy

- **Unit:** `resolveHealthScenario()` for all axis combinations.
- **Widget:** One golden/smoke test per variant per tab (layout shell + key CTA).
- **Integration:** Flip `userSessionProvider` override in tests to walk all scenarios.

---

## Decisions log

| Topic | Decision |
|-------|----------|
| Guest Health/Reports | Always **whole-family, multi-user** sample |
| Pending results | **Per family member** flag |
| Phone verification | **Once per account**; gates checkout; optional phones on members |

---

## Related

- `ui_ux.png` — visual source of truth for layout
- `lib/core/theme/` — design tokens
- `.cursor/rules/app-session-flows.mdc` — AI memory for this model
