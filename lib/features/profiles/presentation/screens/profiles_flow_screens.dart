import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_asset_image.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_buttons.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_providers.dart';
import 'package:dr_swift_diagnostics/features/profiles/data/health_profile_data.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const _navy = Color(0xFF071B3A);
const _muted = Color(0xFF667085);

class ProfilesGridScreen extends StatelessWidget {
  const ProfilesGridScreen({required this.profiles, super.key});

  final List<HealthProfileData> profiles;

  @override
  Widget build(BuildContext context) {
    return DsScaffold(
      safeArea: false,
      body: CustomScrollView(
        slivers: [
          const _ProfileAppBar(
            title: 'Health Profiles',
            subtitle: 'Curated health profiles for you',
            showBack: true,
          ).asSliver(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _SearchBox(),
                const SizedBox(height: 18),
                GridView.builder(
                  itemCount: profiles.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.78,
                  ),
                  itemBuilder: (context, index) {
                    final profile = profiles[index];
                    return _ProfileGridCard(profile: profile);
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({required this.profile, super.key});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context) {
    return DsScaffold(
      safeArea: false,
      body: CustomScrollView(
        slivers: [
          _ProfileAppBar(
            title: profile.name,
            showBack: true,
            trailing: Icons.ios_share_rounded,
          ).asSliver(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _HeroProfileCard(profile: profile),
                const SizedBox(height: 14),
                _InfoCard(
                  title: 'What is it for?',
                  child: Text(profile.whatIsItFor, style: _bodyStyle),
                ),
                const SizedBox(height: 10),
                _InfoCard(
                  title: 'Highlights',
                  child: Column(
                    children: [
                      for (final item in profile.highlights)
                        _CheckLine(label: item),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => context
                              .push('/profiles/${profile.slug}/more-info'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(80, 28),
                          ),
                          child: const Text('View more'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                DsOutlineButton(
                  label: 'View Tests Included',
                  onPressed: () =>
                      context.push('/profiles/${profile.slug}/tests'),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTestsScreen extends StatelessWidget {
  const ProfileTestsScreen({required this.profile, super.key});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context) {
    return DsScaffold(
      safeArea: false,
      body: Column(
        children: [
          _ProfileAppBar(title: profile.name, showBack: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              children: [
                Text(
                  'Tests Included (${profile.testCount})',
                  style: _sectionTitle,
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: _cardDecoration,
                  child: Column(
                    children: [
                      for (var i = 0; i < profile.tests.length; i++) ...[
                        _TestRow(test: profile.tests[i]),
                        if (i < profile.tests.length - 1)
                          const Divider(height: 1, indent: 16),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: DsOutlineButton(
              label: 'View All ${profile.testCount} Tests',
              onPressed: () =>
                  context.push('/profiles/${profile.slug}/more-info'),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMoreInfoScreen extends StatelessWidget {
  const ProfileMoreInfoScreen({required this.profile, super.key});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context) {
    return DsScaffold(
      safeArea: false,
      body: Column(
        children: [
          _ProfileAppBar(title: profile.name, showBack: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                _InfoCard(
                  title: 'Who should take this?',
                  child: Text(profile.whoShouldTakeThis, style: _bodyStyle),
                ),
                const SizedBox(height: 10),
                _InfoCard(
                  title: 'Preparation',
                  child: Column(
                    children: [
                      for (final item in profile.preparation)
                        _CheckLine(label: item),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const _InfoCard(
                  title: 'Why Choose Dr Swift?',
                  child: Column(
                    children: [
                      _IconLine(
                        icon: Icons.biotech_outlined,
                        title: 'Accurate Results',
                        subtitle: 'NABL accredited labs',
                      ),
                      _IconLine(
                        icon: Icons.groups_outlined,
                        title: 'Trusted by 100k+ Families',
                        subtitle: 'For their health',
                      ),
                      _IconLine(
                        icon: Icons.home_outlined,
                        title: 'At-Home Collection',
                        subtitle: 'From comfort of home/office',
                      ),
                      _IconLine(
                        icon: Icons.description_outlined,
                        title: 'Digital Reports',
                        subtitle: 'Secure & easy to understand',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _BottomPriceBar(profile: profile),
        ],
      ),
    );
  }
}

class AddedToCartScreen extends StatelessWidget {
  const AddedToCartScreen({required this.profile, super.key});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context) {
    return DsScaffold(
      safeArea: false,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
          const SizedBox(height: 8),
          const _SuccessMark(size: 76),
          const SizedBox(height: 22),
          const Text(
            'Added to Cart!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            profile.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _muted,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          _CartSummaryCard(profile: profile),
          const SizedBox(height: 16),
          DsOutlineButton(
            label: 'Continue Browsing',
            onPressed: () => context.go(RoutePaths.tests),
          ),
          const SizedBox(height: 12),
          DsPrimaryButton(
            label: 'View Cart',
            onPressed: () => context.push('/cart/${profile.slug}'),
          ),
        ],
      ),
    );
  }
}

class CartScreen extends ConsumerWidget {
  const CartScreen({required this.profile, super.key});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(healthProfilesProvider);
    final suggestions = profilesAsync.maybeWhen(
      data: (profiles) =>
          profiles.where((item) => item.slug != profile.slug).toList(),
      orElse: () => const <HealthProfileData>[],
    );

    return DsScaffold(
      safeArea: false,
      body: Column(
        children: [
          const _ProfileAppBar(
            title: 'My Cart',
            subtitle: '1 Item',
            showBack: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              children: [
                _CartProductCard(profile: profile),
                const SizedBox(height: 18),
                const Text('You May Also Like', style: _sectionTitle),
                const SizedBox(height: 10),
                SizedBox(
                  height: 130,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: suggestions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) =>
                        _SuggestionCard(profile: suggestions[index]),
                  ),
                ),
              ],
            ),
          ),
          _CartTotalBar(profile: profile),
        ],
      ),
    );
  }
}

class SlotSelectionScreen extends StatefulWidget {
  const SlotSelectionScreen({required this.profile, super.key});

  final HealthProfileData profile;

  @override
  State<SlotSelectionScreen> createState() => _SlotSelectionScreenState();
}

class _SlotSelectionScreenState extends State<SlotSelectionScreen> {
  var _selectedDay = 2;
  var _selectedSlot = 1;

  static const _days = [
    ('Today', '20 May'),
    ('Tue', '21 May'),
    ('Wed', '22 May'),
    ('Thu', '23 May'),
    ('Fri', '24 May'),
  ];

  static const _slots = [
    '7:00 AM - 9:00 AM',
    '9:00 AM - 11:00 AM',
    '11:00 AM - 1:00 PM',
    '3:00 PM - 5:00 PM',
    '5:00 PM - 7:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return DsScaffold(
      safeArea: false,
      body: Column(
        children: [
          const _ProfileAppBar(title: 'Select Date & Time', showBack: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              children: [
                const Row(
                  children: [
                    Text('Select Date', style: _sectionTitle),
                    Spacer(),
                    Icon(
                      Icons.calendar_today_outlined,
                      color: _navy,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 68,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _days.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final selected = _selectedDay == index;
                      return _ChoicePill(
                        top: _days[index].$1,
                        bottom: _days[index].$2,
                        selected: selected,
                        onTap: () => setState(() => _selectedDay = index),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Select Time Slot', style: _sectionTitle),
                const SizedBox(height: 12),
                for (var i = 0; i < _slots.length; i++) ...[
                  _SlotButton(
                    label: _slots[i],
                    selected: _selectedSlot == i,
                    onTap: () => setState(() => _selectedSlot = i),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          _ContinueBar(
            profile: widget.profile,
            onContinue: () => context.push('/checkout/${widget.profile.slug}'),
          ),
        ],
      ),
    );
  }
}

class ConfirmDetailsScreen extends StatelessWidget {
  const ConfirmDetailsScreen({required this.profile, super.key});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context) {
    return DsScaffold(
      safeArea: false,
      body: Column(
        children: [
          const _ProfileAppBar(title: 'Confirm Details', showBack: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              children: [
                Container(
                  decoration: _cardDecoration,
                  child: Column(
                    children: [
                      _ConfirmRow(
                        icon: Icons.science_outlined,
                        iconColor: const Color(0xFF24A8E0),
                        eyebrow: 'Profile Selected',
                        title: profile.name,
                        subtitle: '${profile.testCount} Tests',
                      ),
                      const Divider(height: 1, indent: 56),
                      const _ConfirmRow(
                        icon: Icons.event_available_outlined,
                        iconColor: Color(0xFF24B36B),
                        eyebrow: 'Appointment',
                        title: 'Wed, 22 May 2025',
                        subtitle: '9:00 AM - 11:00 AM',
                      ),
                      const Divider(height: 1, indent: 56),
                      const _ConfirmRow(
                        icon: Icons.location_on_outlined,
                        iconColor: Color(0xFFFF9700),
                        eyebrow: 'Address',
                        title: 'Home',
                        subtitle:
                            '2-4-123, Street No. 5\nHyderabad, Telangana - 500001',
                      ),
                      const Divider(height: 1, indent: 56),
                      const _ConfirmRow(
                        icon: Icons.phone_iphone_rounded,
                        iconColor: Color(0xFF24A8E0),
                        eyebrow: 'Mobile Number',
                        title: '+91 98765 43210',
                        subtitle: '',
                      ),
                      const Divider(height: 1),
                      _PaymentSummary(profile: profile),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: DsPrimaryButton(
              label: 'Confirm & Pay',
              onPressed: () => context.push('/orders/${profile.slug}'),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({required this.profile, super.key});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context) {
    return DsScaffold(
      safeArea: false,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => context.go(RoutePaths.tests),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
          const SizedBox(height: 6),
          const _SuccessMark(size: 76),
          const SizedBox(height: 22),
          const Text(
            'Booking Confirmed!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your appointment is scheduled',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MiniProfileLine(profile: profile),
                const Divider(height: 24),
                const _IconTextLine(
                  icon: Icons.calendar_today_outlined,
                  title: 'Wed, 22 May 2025',
                  subtitle: '9:00 AM - 11:00 AM',
                ),
                const Divider(height: 24),
                const Text(
                  'Booking ID',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'DSD12S0522001',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'We will collect your sample from the provided address.',
                  style: _bodyStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DsOutlineButton(label: 'Add to Calendar', onPressed: () {}),
          const SizedBox(height: 12),
          DsPrimaryButton(
            label: 'Track My Booking',
            onPressed: () => context.go(RoutePaths.reports),
          ),
        ],
      ),
    );
  }
}

class _ProfileGridCard extends StatelessWidget {
  const _ProfileGridCard({required this.profile});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/profiles/${profile.slug}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: _cardDecoration,
        child: Row(
          children: [
            _IconBubble(profile: profile, size: 46, iconSize: 31),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.shortName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _tileTitle,
                  ),
                  const SizedBox(height: 4),
                  Text('${profile.testCount} Tests', style: _caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroProfileCard extends StatelessWidget {
  const _HeroProfileCard({required this.profile});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconBubble(profile: profile, size: 64, iconSize: 43),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            profile.name,
                            style: const TextStyle(
                              color: _navy,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const Text(
                          'Most Popular',
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profile.testCount} Tests',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(profile.description, style: _bodyStyle),
          const SizedBox(height: 14),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Tag(label: 'Home Collection', icon: Icons.home_outlined),
              _Tag(
                label: 'Reports in 24 Hrs',
                icon: Icons.receipt_long_outlined,
              ),
              _Tag(label: 'All Ages', icon: Icons.groups_outlined),
            ],
          ),
          const SizedBox(height: 18),
          _PriceLine(profile: profile),
          const SizedBox(height: 12),
          DsPrimaryButton(
            label: 'Add to Cart',
            onPressed: () => context.push('/profiles/${profile.slug}/added'),
          ),
        ],
      ),
    );
  }
}

class _ProfileAppBar extends StatelessWidget {
  const _ProfileAppBar({
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
        child: SizedBox(
          height: 54,
          child: Row(
            children: [
              SizedBox(
                width: 44,
                child: showBack
                    ? IconButton(
                        onPressed: () => context.canPop()
                            ? context.pop()
                            : context.go(RoutePaths.tests),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                        ),
                      )
                    : null,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(
                width: 44,
                child: trailing == null
                    ? null
                    : IconButton(
                        onPressed: () {},
                        icon: Icon(trailing, size: 20),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration:
          _cardDecoration.copyWith(borderRadius: BorderRadius.circular(10)),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: _muted, size: 20),
          SizedBox(width: 10),
          Text(
            'Search profiles',
            style: TextStyle(
              color: _muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _sectionTitle),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _BottomPriceBar extends StatelessWidget {
  const _BottomPriceBar({required this.profile});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Expanded(child: _PriceLine(profile: profile, compact: true)),
            const SizedBox(width: 14),
            SizedBox(
              width: 156,
              child: DsPrimaryButton(
                label: 'Add to Cart',
                onPressed: () =>
                    context.push('/profiles/${profile.slug}/added'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartTotalBar extends StatelessWidget {
  const _CartTotalBar({required this.profile});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  profile.formattedPrice,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'You save ₹400',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            DsPrimaryButton(
              label: 'Proceed to Book',
              onPressed: () => context.push('/book/${profile.slug}'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueBar extends StatelessWidget {
  const _ContinueBar({required this.profile, required this.onContinue});

  final HealthProfileData profile;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Payable',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    profile.formattedPrice,
                    style: const TextStyle(
                      color: _navy,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 158,
              child: DsPrimaryButton(label: 'Continue', onPressed: onContinue),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartSummaryCard extends StatelessWidget {
  const _CartSummaryCard({required this.profile});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: 'In Your Cart (1 item)',
      child: _MiniProfileLine(profile: profile, showPrice: true),
    );
  }
}

class _CartProductCard extends StatelessWidget {
  const _CartProductCard({required this.profile});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MiniProfileLine(profile: profile, showPrice: true),
              ),
              const Icon(Icons.delete_outline_rounded, color: _muted, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              _QuantityButton(icon: Icons.remove_rounded, enabled: false),
              SizedBox(width: 10),
              Text(
                '1',
                style: TextStyle(
                  color: _navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 10),
              _QuantityButton(icon: Icons.add_rounded, enabled: true),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.profile});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: _cardDecoration,
        child: Column(
          children: [
            _IconBubble(profile: profile, size: 44, iconSize: 30),
            const SizedBox(height: 7),
            Text(
              profile.shortName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _tileTitle.copyWith(fontSize: 11),
            ),
            const SizedBox(height: 3),
            Text(
              profile.formattedPrice,
              style: const TextStyle(
                color: _navy,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 30,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                child: const Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniProfileLine extends StatelessWidget {
  const _MiniProfileLine({required this.profile, this.showPrice = false});

  final HealthProfileData profile;
  final bool showPrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconBubble(profile: profile, size: 44, iconSize: 30),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _tileTitle,
              ),
              const SizedBox(height: 3),
              Text('${profile.testCount} Tests', style: _caption),
            ],
          ),
        ),
        if (showPrice) ...[
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                profile.formattedPrice,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                profile.discount,
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  const _PaymentSummary({required this.profile});

  final HealthProfileData profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment Summary', style: _sectionTitle),
          const SizedBox(height: 12),
          _AmountRow(
            label: 'Items Total',
            value: profile.formattedOriginalPrice,
          ),
          const SizedBox(height: 7),
          const _AmountRow(
            label: 'Discount',
            value: '- ₹400',
            valueColor: AppColors.success,
          ),
          const Divider(height: 20),
          _AmountRow(
            label: 'Total Payable',
            value: profile.formattedPrice,
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({
    required this.icon,
    required this.iconColor,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: iconColor.withValues(alpha: 0.12),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(title, style: _tileTitle),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(subtitle, style: _caption.copyWith(height: 1.35)),
                ],
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('Change')),
        ],
      ),
    );
  }
}

class _TestRow extends StatelessWidget {
  const _TestRow({required this.test});

  final ProfileTestItem test;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(test.name, style: _tileTitle),
                const SizedBox(height: 4),
                Text(test.subtitle, style: _caption),
              ],
            ),
          ),
          Text(
            '₹${test.price}',
            style: const TextStyle(
              color: _navy,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({required this.profile, this.compact = false});

  final HealthProfileData profile;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: compact ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Text(
          profile.formattedPrice,
          style: TextStyle(
            color: _navy,
            fontSize: compact ? 22 : 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          profile.formattedOriginalPrice,
          style: const TextStyle(
            color: _muted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF8EF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            profile.discount,
            style: const TextStyle(
              color: AppColors.success,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.top,
    required this.bottom,
    required this.selected,
    required this.onTap,
  });

  final String top;
  final String bottom;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 72,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF4EEFF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primaryVibrant : AppColors.divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              top,
              style: TextStyle(
                color: selected ? AppColors.primaryVibrant : _navy,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              bottom,
              style: TextStyle(
                color: selected ? AppColors.primaryVibrant : _muted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlotButton extends StatelessWidget {
  const _SlotButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 190,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF4EEFF) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? AppColors.primaryVibrant : AppColors.divider,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.primaryVibrant : _navy,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.profile,
    required this.size,
    required this.iconSize,
  });

  final HealthProfileData profile;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: profile.color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: DsSvg(profile.iconAsset, size: iconSize),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: _navy),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: _navy,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  const _CheckLine({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_rounded, color: Color(0xFF0F6D8B), size: 15),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: _bodyStyle)),
        ],
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryVibrant, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _tileTitle),
                const SizedBox(height: 2),
                Text(subtitle, style: _caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconTextLine extends StatelessWidget {
  const _IconTextLine({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _navy, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _tileTitle),
              const SizedBox(height: 3),
              Text(subtitle, style: _caption),
            ],
          ),
        ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.value,
    this.valueColor = _navy,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: bold ? _navy : _muted,
            fontSize: 12,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 12,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.enabled});

  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: enabled ? Colors.white : const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Icon(
        icon,
        color: enabled ? AppColors.primaryVibrant : _muted,
        size: 17,
      ),
    );
  }
}

class _SuccessMark extends StatelessWidget {
  const _SuccessMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFF13A86B),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 48),
      ),
    );
  }
}

extension on Widget {
  Widget asSliver() => SliverToBoxAdapter(child: this);
}

final _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: AppColors.divider),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF101828).withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ],
);

const _sectionTitle =
    TextStyle(color: _navy, fontSize: 13, fontWeight: FontWeight.w900);
const _tileTitle = TextStyle(
  color: _navy,
  fontSize: 12.5,
  fontWeight: FontWeight.w800,
  height: 1.18,
);
const _caption =
    TextStyle(color: _muted, fontSize: 10.5, fontWeight: FontWeight.w600);
const _bodyStyle = TextStyle(
  color: Color(0xFF344054),
  fontSize: 11.5,
  fontWeight: FontWeight.w600,
  height: 1.45,
);
