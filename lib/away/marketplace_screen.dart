import 'package:flutter/material.dart';

void main() {
  runApp(const MarketplaceApp());
}

class MarketplaceApp extends StatelessWidget {
  const MarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1DE9B6),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const MarketplaceScreen(),
    );
  }
}

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {},
        ),
        title: const Text(
          'Marketplace',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F4),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Amoxicillin',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  suffixIcon: Icon(Icons.cancel, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                _buildFilterChip('Urgent', isSelected: true, icon: Icons.bolt),
                const SizedBox(width: 10),
                _buildFilterChip('Near-Expiry', icon: Icons.priority_high),
                const SizedBox(width: 10),
                _buildFilterChip('Distance', hasDropdown: true),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Results Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '32 RESULTS FOUND',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                Row(
                  children: const [
                    Icon(Icons.tune, size: 16, color: Color(0xFF1DE9B6)),
                    SizedBox(width: 5),
                    Text(
                      'FILTERS',
                      style: TextStyle(
                        color: Color(0xFF1DE9B6),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Product List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildProductCard(
                  name: 'Amoxicillin Capsules',
                  specs: '500mg • 10x10 Strip',
                  price: '24.50',
                  distance: '0.8 km away',
                  pharmacy: 'Central Pharma',
                  tag: 'NEAR EXPIRY',
                  tagColor: Colors.orange[100]!,
                  tagTextColor: Colors.orange[800]!,
                  imageColor: const Color(0xFFE0F2F1),
                ),
                _buildProductCard(
                  name: 'Amoxiclav Tablet',
                  specs: '625mg • 14 Tablets',
                  price: '32.00',
                  distance: '1.2 km away',
                  pharmacy: 'MediCenter',
                  tag: 'URGENT STOCK',
                  tagColor: const Color(0xFFE0F7FA),
                  tagTextColor: const Color(0xFF00ACC1),
                  imageColor: const Color(0xFFFFEBEE),
                ),
                _buildProductCard(
                  name: 'Amoxicillin Oral Susp.',
                  specs: '250mg/5ml • 100ml Bottle',
                  price: '18.75',
                  distance: '3.5 km away',
                  pharmacy: 'Global Health',
                  tag: 'NORMAL',
                  tagColor: const Color(0xFFF5F5F5),
                  tagTextColor: Colors.grey[600]!,
                  imageColor: const Color(0xFFFFF9C4),
                ),
                _buildProductCard(
                  name: 'Amoxicillin 250mg',
                  specs: 'Capsules • 10 Strips',
                  price: '12.00',
                  oldPrice: '22.00',
                  distance: '4.2 km away',
                  pharmacy: 'Discount Pharma',
                  tag: 'EXP: OCT 2024',
                  tagColor: Colors.orange[50]!,
                  tagTextColor: Colors.orange[900]!,
                  imageColor: const Color(0xFFF1F8E9),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF0F172A),
        icon: const Icon(Icons.map_outlined, color: Colors.white),
        label: const Text('View Map', style: TextStyle(color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false, IconData? icon, bool hasDropdown = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1DE9B6) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? const Color(0xFF1DE9B6) : Colors.grey[300]!),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.orange),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (hasDropdown) ...[
            const SizedBox(width: 5),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.black54),
          ],
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String name,
    required String specs,
    required String price,
    String? oldPrice,
    required String distance,
    required String pharmacy,
    required String tag,
    required Color tagColor,
    required Color tagTextColor,
    required Color imageColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: imageColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medication_outlined, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 15),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: tagColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(color: tagTextColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(specs, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '\$$price',
                      style: const TextStyle(
                        color: Color(0xFF1DE9B6),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(' / unit', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    if (oldPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '\$$oldPrice',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '$distance • $pharmacy',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Cart Button
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(top: 40),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF1DE9B6), size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1DE9B6),
        unselectedItemColor: Colors.grey[400],
        currentIndex: 1, // Search is active
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'SEARCH'),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('2'),
              backgroundColor: Color(0xFF1DE9B6),
              child: Icon(Icons.shopping_basket_outlined),
            ),
            label: 'ORDERS',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'PROFILE'),
        ],
      ),
    );
  }
}
