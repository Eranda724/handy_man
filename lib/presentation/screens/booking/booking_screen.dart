import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:handy_man/core/enums/booking_status.dart';
import 'package:handy_man/core/enums/time_slot.dart';
import 'package:handy_man/data/models/booking.dart';
import 'package:handy_man/data/models/service_provider.dart';
import 'package:handy_man/domain/cost_calculator.dart';
import 'package:handy_man/domain/validators.dart';
import 'package:handy_man/presentation/state/bookings_notifier.dart';
import 'package:handy_man/presentation/screens/booking/booking_confirm_screen.dart';

class BookingScreen extends StatefulWidget {
  final ServiceProvider provider;

  const BookingScreen({super.key, required this.provider});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _descController = TextEditingController();

  DateTime? _selectedDate;
  TimeSlot? _selectedSlot;
  int _estimatedHours = 1;
  bool _isEdited = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _markEdited() {
    if (!_isEdited) setState(() => _isEdited = true);
  }

  int get _maxHours {
    if (_selectedSlot == null) return 8;
    return 17 - _selectedSlot!.startHour;
  }

  void _updateHours() {
    if (_estimatedHours > _maxHours) {
      _estimatedHours = _maxHours > 0 ? _maxHours : 1;
    }
  }

  double get _labourCost =>
      widget.provider.hourlyRate * _estimatedHours.toDouble();
  double get _weekendSurcharge =>
      (_selectedDate?.weekday == DateTime.saturday) ? _labourCost * 0.15 : 0;
  double get _totalCost =>
      _labourCost + CostCalculator.visitingCharge + _weekendSurcharge;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    final maxDate = now.add(const Duration(days: 30));

    final picked = await showDatePicker(
      context: context,
      initialDate: tomorrow.weekday == DateTime.sunday
          ? tomorrow.add(const Duration(days: 1))
          : tomorrow,
      firstDate: tomorrow,
      lastDate: maxDate,
      selectableDayPredicate: (day) => day.weekday != DateTime.sunday,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedSlot = null; // Clear the selected time when the date is changed
        _markEdited();
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    final notifier = context.read<BookingsNotifier>();
    final dateStr = DateFormat('yyyyMMdd').format(_selectedDate!);
    final uniqueId =
        'FX-$dateStr-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}';

    final booking = Booking(
      id: uniqueId,
      providerId: widget.provider.id,
      providerName: widget.provider.name,
      serviceName: widget.provider.categoryId,
      customerName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      date: _selectedDate!,
      timeSlot: _selectedSlot!,
      estimatedHours: _estimatedHours,
      jobDescription: _descController.text.trim(),
      labourCost: _labourCost,
      visitingCharge: CostCalculator.visitingCharge,
      weekendSurcharge: _weekendSurcharge,
      totalCost: _totalCost,
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
    );

    final success = notifier.addBooking(booking);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This slot was just booked by someone else!'),
        ),
      );
      return;
    }

    setState(() => _isEdited = false); // Prevent the unsaved changes alert from showing

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmationScreen(bookingId: uniqueId),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_isEdited) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to leave?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final bookedSlots = _selectedDate == null
        ? <TimeSlot>[]
        : context.watch<BookingsNotifier>().getBookedSlots(
            widget.provider.id,
            _selectedDate!,
          );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Book Service')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: Validators.validateName,
                onChanged: (_) => _markEdited(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
                onChanged: (_) => _markEdited(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 2,
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'Cannot be empty'
                    : null,
                onChanged: (_) => _markEdited(),
              ),
              const SizedBox(height: 24),
              ListTile(
                title: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                ),
                trailing: const Icon(Icons.calendar_today),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: _pickDate,
              ),
              const SizedBox(height: 24),
              const Text(
                'Time Slot',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: TimeSlot.values.map((slot) {
                  final isBooked = bookedSlots.contains(slot);
                  return ChoiceChip(
                    label: Text(slot.label),
                    selected: _selectedSlot == slot,
                    onSelected: isBooked
                        ? null
                        : (selected) {
                            setState(() {
                              _selectedSlot = selected ? slot : null;
                              _updateHours();
                              _markEdited();
                            });
                          },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    'Estimated Hours:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _estimatedHours > 1
                        ? () {
                            setState(() {
                              _estimatedHours--;
                              _markEdited();
                            });
                          }
                        : null,
                  ),
                  Text(
                    '$_estimatedHours',
                    style: const TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: _estimatedHours < _maxHours
                        ? () {
                            setState(() {
                              _estimatedHours++;
                              _markEdited();
                            });
                          }
                        : null,
                  ),
                ],
              ),
              if (_selectedSlot != null)
                Text(
                  'Max $_maxHours hours for this slot',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Job Description'),
                maxLines: 3,
                maxLength: 300,
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'Cannot be empty'
                    : null,
                onChanged: (_) => _markEdited(),
              ),
              const Divider(height: 32),
              const Text(
                'Cost Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildCostRow(
                'Labour (LKR ${widget.provider.hourlyRate} x $_estimatedHours)',
                _labourCost,
              ),
              _buildCostRow('Visiting Charge', CostCalculator.visitingCharge),
              if (_weekendSurcharge > 0)
                _buildCostRow('Weekend Surcharge (15%)', _weekendSurcharge),
              const Divider(),
              _buildCostRow('Total Estimate', _totalCost, isBold: true),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            'LKR ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
