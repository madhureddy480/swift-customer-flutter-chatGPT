import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_buttons.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:dr_swift_diagnostics/features/cart/presentation/providers/cart_providers.dart';
import 'package:dr_swift_diagnostics/features/checkout/domain/checkout_models.dart';
import 'package:dr_swift_diagnostics/features/checkout/presentation/providers/checkout_controller.dart';
import 'package:dr_swift_diagnostics/features/session/presentation/session_controller.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

const _ink = Color(0xFF1A1C1E);
const _screenBg = Color(0xFFF4F7FA);

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _date;
  String? _slot;

  static const _slots = [
    '7:00 AM – 9:00 AM',
    '9:00 AM – 11:00 AM',
    '11:00 AM – 1:00 PM',
    '2:00 PM – 4:00 PM',
    '4:00 PM – 6:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(userSessionProvider);
      _nameController.text = session.accountHolder?.displayName ?? '';
      _mobileController.text = '+919876543210';
      setState(() {
        _date = DateTime.now().add(const Duration(days: 1));
        _slot = _slots.first;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDate: _date ?? DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _placeOrder() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _date == null || _slot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }

    final cart = ref.read(cartControllerProvider);
    if (cart.isEmpty) {
      context.go(RoutePaths.shoppingCart);
      return;
    }

    final details = CheckoutDetails(
      patientName: _nameController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      collectionAddress: _addressController.text.trim(),
      collectionDate: _date!,
      collectionTimeSlot: _slot!,
    );

    final order =
        await ref.read(checkoutControllerProvider.notifier).placeOrder(
              details: details,
              totalRupees: cart.totalRupees,
            );
    if (!mounted || order == null) return;

    await ref.read(cartControllerProvider.notifier).clear();
    if (!mounted) return;
    context.go(RoutePaths.orderConfirmation);
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartControllerProvider);
    final checkout = ref.watch(checkoutControllerProvider);

    return DsScaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: ColoredBox(
        color: _screenBg,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const _CheckoutProgressHeader(currentStep: 3),
              const SizedBox(height: 12),
              _Section(
                title: 'Patient details',
                child: Column(
                  children: [
                    _Field(
                      controller: _nameController,
                      label: 'Patient name',
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      autofillHints: const [AutofillHints.name],
                      validator: (value) =>
                          _required(value, 'Enter patient name'),
                    ),
                    _Field(
                      controller: _mobileController,
                      label: 'Mobile number',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      validator: _phoneValidator,
                    ),
                    _Field(
                      controller: _emailController,
                      label: 'Email (optional)',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      validator: _emailValidator,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Section(
                title: 'Sample collection',
                child: Column(
                  children: [
                    _Field(
                      controller: _addressController,
                      label: 'Collection address',
                      maxLines: 3,
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.newline,
                      textCapitalization: TextCapitalization.sentences,
                      autofillHints: const [AutofillHints.fullStreetAddress],
                      validator: (value) =>
                          _required(value, 'Enter collection address'),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _date == null
                            ? 'Select date'
                            : DateFormat('EEE, d MMM yyyy').format(_date!),
                      ),
                      subtitle: const Text('Choose a home collection date'),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: checkout.isPlacingOrder ? null : _pickDate,
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: _slot,
                      items: _slots
                          .map(
                            (slot) => DropdownMenuItem(
                              value: slot,
                              child: Text(slot),
                            ),
                          )
                          .toList(),
                      onChanged: checkout.isPlacingOrder
                          ? null
                          : (value) => setState(() => _slot = value),
                      validator: (value) =>
                          value == null ? 'Select a time slot' : null,
                      decoration: const InputDecoration(labelText: 'Time slot'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Section(
                title: 'Order summary',
                child: Column(
                  children: [
                    if (cart.items.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child:
                            Text('Your cart is empty. Add a test to continue.'),
                      )
                    else
                      for (final item in cart.items)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(child: Text(item.name)),
                              Text(
                                item.formattedLineTotal,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                    const Divider(),
                    Row(
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '₹${cart.totalRupees}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: _ink,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (checkout.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  checkout.errorMessage!,
                  style: const TextStyle(
                    color: Color(0xFFD64545),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              DsPrimaryButton(
                label: 'Place Order',
                isLoading: checkout.isPlacingOrder,
                onPressed: checkout.isPlacingOrder || cart.isEmpty
                    ? null
                    : _placeOrder,
              ),
              const SizedBox(height: 10),
              DsOutlineButton(
                label: 'Cancel',
                onPressed: checkout.isPlacingOrder ? null : () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? value, String message) {
    return value == null || value.trim().isEmpty ? message : null;
  }

  String? _phoneValidator(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return 'Enter a valid mobile number';
    return null;
  }

  String? _emailValidator(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return null;
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    return valid ? null : 'Enter a valid email address';
  }
}

class _CheckoutProgressHeader extends StatelessWidget {
  const _CheckoutProgressHeader({required this.currentStep});

  final int currentStep;

  static const _steps = ['Cart', 'Sign in', 'Details', 'Confirm'];

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Checkout progress',
      child: Row(
        children: [
          for (var index = 0; index < _steps.length; index++) ...[
            Expanded(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: index <= currentStep
                        ? const Color(0xFF662FC1)
                        : const Color(0xFFE2E6EE),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: index <= currentStep ? Colors.white : _ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _steps[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (index < _steps.length - 1) const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E6EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        autofillHints: autofillHints,
        validator: validator,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
