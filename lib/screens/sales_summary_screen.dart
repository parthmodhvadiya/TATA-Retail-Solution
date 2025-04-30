import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/invoice_provider.dart';

class SalesSummaryScreen extends StatefulWidget {
  const SalesSummaryScreen({super.key});

  @override
  State<SalesSummaryScreen> createState() => _SalesSummaryScreenState();
}

class _SalesSummaryScreenState extends State<SalesSummaryScreen> {
  @override
  void initState() {
    super.initState();
    // Load invoices when the screen is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InvoiceProvider>(context, listen: false).loadInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Summary'),
      ),
      body: Consumer<InvoiceProvider>(
        builder: (context, invoiceProvider, child) {
          if (invoiceProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (invoiceProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${invoiceProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      invoiceProvider.loadInvoices();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final invoices = invoiceProvider.invoices;
          if (invoices.isEmpty) {
            return const Center(
              child: Text('No sales data available.'),
            );
          }

          // Calculate summary statistics
          final totalSales =
              invoices.fold(0.0, (sum, invoice) => sum + invoice.finalAmount);
          final totalGst =
              invoices.fold(0.0, (sum, invoice) => sum + invoice.gstAmount);
          final totalInvoices = invoices.length;
          final averageSale = totalSales / totalInvoices;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sales Overview',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SummaryItem(
                          label: 'Total Sales',
                          value: '₹${totalSales.toStringAsFixed(2)}',
                          icon: Icons.attach_money,
                        ),
                        _SummaryItem(
                          label: 'Total GST',
                          value: '₹${totalGst.toStringAsFixed(2)}',
                          icon: Icons.receipt,
                        ),
                        _SummaryItem(
                          label: 'Total Invoices',
                          value: totalInvoices.toString(),
                          icon: Icons.receipt_long,
                        ),
                        _SummaryItem(
                          label: 'Average Sale',
                          value: '₹${averageSale.toStringAsFixed(2)}',
                          icon: Icons.trending_up,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recent Sales',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...invoices.take(5).map((invoice) => ListTile(
                              title: Text('Invoice #${invoice.id}'),
                              subtitle: Text(
                                'Customer: ${invoice.customerName}',
                              ),
                              trailing: Text(
                                '₹${invoice.finalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
