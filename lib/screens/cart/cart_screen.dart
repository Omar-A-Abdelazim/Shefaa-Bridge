import 'package:flutter/material.dart';
import 'package:pharmacy_app/providers/credits_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../main/main_navigation_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2F1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF1DE9B6),
                    size: 60,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Order Placed Successfully!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Thank you for your trust. Your order is being processed and will reach you as soon as possible. Get ready to receive your medicines!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .clearCart();

                      // Award credits for successful purchase
                      Provider.of<CreditsProvider>(context, listen: false)
                          .addCredits(100);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Purchase successful! +100 credits added')),
                      );

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const MainNavigationScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DE9B6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Back to Home',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Cart',
          style:
              TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: item.product.imageColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                item.product.imagePlaceholder,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 8, color: Colors.black54),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  item.product.pharmacy,
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${item.product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      color: Color(0xFF1DE9B6),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              _buildQtyBtn(Icons.remove, () {
                                cart.updateQuantity(index, -1);
                              }),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text('${item.quantity}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              _buildQtyBtn(Icons.add, () {
                                cart.updateQuantity(index, 1);
                              }),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _buildOrderSummary(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: Colors.black54),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5)),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 10),
          _buildSummaryRow(
              'Delivery Fee', '\$${cart.deliveryFee.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
          ),
          _buildSummaryRow('Total Amount', '\$${cart.total.toStringAsFixed(2)}',
              isTotal: true),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showSuccessDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1DE9B6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Checkout Now',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? const Color(0xFF1A1A1A) : Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 22 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? const Color(0xFF1DE9B6) : const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}
