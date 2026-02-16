import 'package:flutter/material.dart';
import '../marketplace/marketplace_screen.dart';
import '../cart/cart_screen.dart';
import '../listing/add_listing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WELCOME BACK,',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        'City Pharmacy Central',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: Colors.black),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 10)
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search medicines...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Action Cards
              isSmallScreen
                  ? Column(
                      children: [
                        _buildActionCard(
                          context,
                          title: 'Find\nMedicines',
                          subtitle: 'Browse exchange listings &\nbuy supplies.',
                          buttonText: 'Explore Market',
                          buttonColor: Colors.white,
                          buttonTextColor: Colors.black,
                          cardColor: const Color(0xFF1DE9B6),
                          icon: Icons.search,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MarketplaceScreen()),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildActionCard(
                          context,
                          title: 'Sell\nMedicines',
                          subtitle: 'List your excess inventory for\nexchange.',
                          buttonText: 'Post Listing',
                          buttonColor: const Color(0xFF1DE9B6),
                          buttonTextColor: Colors.black,
                          cardColor: const Color(0xFF0F172A),
                          icon: Icons.inventory_2_outlined,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AddNewListingScreen()),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _buildActionCard(
                            context,
                            title: 'Find\nMedicines',
                            subtitle:
                                'Browse exchange listings &\nbuy supplies.',
                            buttonText: 'Explore Market',
                            buttonColor: Colors.white,
                            buttonTextColor: Colors.black,
                            cardColor: const Color(0xFF1DE9B6),
                            icon: Icons.search,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MarketplaceScreen()),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildActionCard(
                            context,
                            title: 'Sell\nMedicines',
                            subtitle:
                                'List your excess inventory for\nexchange.',
                            buttonText: 'Post Listing',
                            buttonColor: const Color(0xFF1DE9B6),
                            buttonTextColor: Colors.black,
                            cardColor: const Color(0xFF0F172A),
                            icon: Icons.inventory_2_outlined,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddNewListingScreen()),
                            ),
                          ),
                        ),
                      ],
                    ),

              const SizedBox(height: 30),

              // Best Selling Medicines
              const Text(
                'Best Selling Medicines',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _buildMedicineCard(index);
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String buttonText,
    required Color buttonColor,
    required Color buttonTextColor,
    required Color cardColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineCard(int index) {
    final List<Map<String, String>> medicines = [
      {
        'name': 'Panadol Advance',
        'desc': 'Paracetamol 500mg - Fast Relief',
        'price': '\$12.50',
        'img': 'assets/images/panadol.png'
      },
      {
        'name': 'Amoxicillin',
        'desc': '500mg Capsules - Antibiotic',
        'price': '\$45.00',
        'img': 'assets/images/amoxicillin.png'
      },
      {
        'name': 'Vitamin C',
        'desc': '1000mg Effervescent Tablets',
        'price': '\$15.00',
        'img': 'assets/images/vit_c.png'
      },
      {
        'name': 'Ibuprofen',
        'desc': '400mg Tablets - Pain Relief',
        'price': '\$8.00',
        'img': 'assets/images/ibuprofen.png'
      },
    ];

    final med = medicines[index % medicines.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(med['img']!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  med['desc']!,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            med['price']!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1DE9B6),
            ),
          ),
        ],
      ),
    );
  }
}
