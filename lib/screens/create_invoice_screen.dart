import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final List<Map<String, dynamic>> _selectedItems = [];
  double _totalAmount = 0.0;
  double _gstAmount = 0.0;
  double _finalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    // Load products when the screen is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    super.dispose();
  }

  void _addItem(Product product, int quantity) {
    setState(() {
      _selectedItems.add({
        'product': product,
        'quantity': quantity,
        'price': product.price * quantity,
        'gstAmount': (product.price * quantity * product.gstRate / 100),
      });
      _calculateTotals();
    });
  }

  void _removeItem(int index) {
    setState(() {
      _selectedItems.removeAt(index);
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    _totalAmount = _selectedItems.fold(0.0, (sum, item) => sum + item['price']);
    _gstAmount =
        _selectedItems.fold(0.0, (sum, item) => sum + item['gstAmount']);
    _finalAmount = _totalAmount + _gstAmount;
  }

  Future<void> _createInvoice() async {
    if (_formKey.currentState!.validate() && _selectedItems.isNotEmpty) {
      // TODO: Implement invoice creation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice created successfully!')),
      );
      Navigator.pop(context);
    } else if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please add at least one item to the invoice')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Invoice'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (productProvider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${productProvider.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              productProvider.loadProducts();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final products = productProvider.products;
                  if (products.isEmpty) {
                    return const Center(
                      child: Text('No products available.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                          'Price: ₹${product.price.toStringAsFixed(2)} | GST: ${product.gstRate}%',
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Add ${product.name}'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        'Available Quantity: ${product.quantity}'),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Quantity',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        final quantity = int.tryParse(value);
                                        if (quantity != null &&
                                            quantity > 0 &&
                                            quantity <= product.quantity) {
                                          _addItem(product, quantity);
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: const Text('Add'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (_selectedItems.isNotEmpty) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Selected Items:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._selectedItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final product = item['product'] as Product;
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                          'Quantity: ${item['quantity']} | Price: ₹${item['price'].toStringAsFixed(2)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeItem(index),
                        ),
                      );
                    }),
                    const Divider(),
                    Text(
                      'Total Amount: ₹${_totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'GST Amount: ₹${_gstAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Final Amount: ₹${_finalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _createInvoice,
                      child: const Text('Create Invoice'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
