import 'package:flutter/material.dart';

class AddNewListingScreen extends StatefulWidget {
  const AddNewListingScreen({super.key});

  @override
  State<AddNewListingScreen> createState() => _AddNewListingScreenState();
}

class _AddNewListingScreenState extends State<AddNewListingScreen> {
  // Controllers
  final _medicineNameController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isPriceCalculated = false;
  int _quantity = 10;

  // Dummy list for medicine suggestions (replace with real API later)
  final List<String> _medicineSuggestions = [
    'Panadol 500mg',
    'Paracetamol 500mg',
    'Amoxicillin 500mg',
    'Ibuprofen 400mg',
    'Vitamin C 1000mg',
    'Aspirin 75mg',
    'Omeprazole 20mg',
    'Ciprofloxacin 500mg',
    'Metformin 500mg',
    'Atorvastatin 20mg',
  ];

  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _medicineNameController.addListener(_onMedicineNameChanged);
    _expiryDateController.addListener(_autoCalculatePrice);
  }

  @override
  void dispose() {
    _medicineNameController.removeListener(_onMedicineNameChanged);
    _expiryDateController.removeListener(_autoCalculatePrice);
    _medicineNameController.dispose();
    _expiryDateController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Show suggestions when typing in medicine name
  void _onMedicineNameChanged() {
    final query = _medicineNameController.text.toLowerCase().trim();
    setState(() {
      _filteredSuggestions = query.isEmpty
          ? []
          : _medicineSuggestions
              .where((med) => med.toLowerCase().contains(query))
              .toList();
    });

    _autoCalculatePrice();
  }

  // Open date picker
  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) {
      setState(() {
        _expiryDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Auto-calculate price
  void _autoCalculatePrice() {
    final name = _medicineNameController.text.trim();
    final expiryText = _expiryDateController.text.trim();

    if (name.isEmpty || expiryText.isEmpty) {
      setState(() {
        _priceController.clear();
        _isPriceCalculated = false;
      });
      return;
    }

    final expiryDate = DateTime.tryParse(expiryText);
    if (expiryDate == null) return;

    final daysLeft = expiryDate.difference(DateTime.now()).inDays;
    if (daysLeft < 0) return;

    // Different base prices for different medicines
    double basePrice = 250.0;
    final lowerName = name.toLowerCase();
    if (lowerName.contains('panadol'))
      basePrice = 300.0;
    else if (lowerName.contains('paracetamol'))
      basePrice = 150.0;
    else if (lowerName.contains('amoxicillin'))
      basePrice = 220.0;
    else if (lowerName.contains('ibuprofen'))
      basePrice = 180.0;
    else if (lowerName.contains('vitamin c')) basePrice = 120.0;

    double expiryFactor =
        daysLeft > 180 ? 1.0 : (daysLeft / 180.0).clamp(0.3, 1.0);
    double quantityFactor = _quantity / 10.0;

    final enforcedPrice = basePrice * expiryFactor * quantityFactor;

    setState(() {
      _priceController.text = enforcedPrice.toStringAsFixed(2);
      _isPriceCalculated = true;
    });
  }

  // Select suggestion from list
  void _selectSuggestion(String suggestion) {
    setState(() {
      _medicineNameController.text = suggestion;
      _filteredSuggestions = [];
    });
    _autoCalculatePrice();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00E5BC);
    const Color secondaryColor = Color(0xFFF1FDFB);
    const Color subTextColor = Color(0xFF757575);
    const Color borderColor = Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add New Listing',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Indicator
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'STEP 1 OF 2',
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                Text(
                  'Medicine Details',
                  style: TextStyle(color: subTextColor, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  height: 4,
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'PRODUCT INFORMATION',
              style: TextStyle(
                  color: subTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5),
            ),
            const SizedBox(height: 20),

            const Text('Medicine Name',
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _medicineNameController,
              decoration: InputDecoration(
                hintText: 'e.g. Panadol 500mg',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: borderColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: borderColor)),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Type to search standard pharmaceutical database',
              style: TextStyle(color: subTextColor, fontSize: 10),
            ),

            // Suggestions List
            if (_filteredSuggestions.isNotEmpty)
              Container(
                height: 150,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: _filteredSuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _filteredSuggestions[index];
                    return ListTile(
                      title: Text(suggestion),
                      onTap: () => _selectSuggestion(suggestion),
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Expiry Date',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _selectExpiryDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: _expiryDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'YYYY-MM-DD',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              suffixIcon: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.grey,
                                  size: 20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: borderColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: borderColor)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Quantity',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove,
                                  color: Colors.grey, size: 20),
                              onPressed: () {
                                if (_quantity > 1) {
                                  setState(() => _quantity--);
                                  _autoCalculatePrice();
                                }
                              },
                            ),
                            Text('$_quantity',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add,
                                  color: Colors.grey, size: 20),
                              onPressed: () {
                                setState(() => _quantity++);
                                _autoCalculatePrice();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Smart Pricing Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryColor.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.insights,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Smart Pricing',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(
                            'Enforced price based on expiry and market demand',
                            style: TextStyle(color: subTextColor, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Enforced Listing Price (\$)',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _priceController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Will be calculated automatically',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  if (_isPriceCalculated)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'This is the maximum allowed price. Editing is not permitted.',
                        style: TextStyle(color: subTextColor, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'VERIFICATION PHOTOS',
              style: TextStyle(
                  color: subTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, color: Colors.grey),
                        SizedBox(height: 4),
                        Text('BOX PHOTO',
                            style: TextStyle(
                                color: subTextColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: borderColor, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, color: primaryColor),
                        SizedBox(height: 4),
                        Text('BATCH/LICENSE',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please ensure the expiry date and batch number are clearly visible in the photos for fast approval.',
                      style: TextStyle(color: Colors.orange, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: ElevatedButton(
          onPressed: () {
            if (!_isPriceCalculated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Price must be calculated first')),
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Listing submitted for approval')),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 54),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Submit Listing',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.black, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
