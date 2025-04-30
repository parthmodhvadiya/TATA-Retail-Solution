const express = require('express');
const router = express.Router();
const Invoice = require('../models/Invoice');

// Get all invoices
router.get('/', async (req, res) => {
  try {
    const invoices = await Invoice.find().sort({ createdAt: -1 });
    res.json(invoices);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get a single invoice
router.get('/:id', async (req, res) => {
  try {
    const invoice = await Invoice.findById(req.params.id);
    if (!invoice) {
      return res.status(404).json({ message: 'Invoice not found' });
    }
    res.json(invoice);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Create a new invoice
router.post('/', async (req, res) => {
  const invoice = new Invoice({
    customerName: req.body.customerName,
    items: req.body.items,
    totalAmount: req.body.totalAmount,
    gstAmount: req.body.gstAmount,
    finalAmount: req.body.finalAmount
  });

  try {
    const newInvoice = await invoice.save();
    res.status(201).json(newInvoice);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Update an invoice
router.patch('/:id', async (req, res) => {
  try {
    const invoice = await Invoice.findById(req.params.id);
    if (!invoice) {
      return res.status(404).json({ message: 'Invoice not found' });
    }

    if (req.body.customerName != null) {
      invoice.customerName = req.body.customerName;
    }
    if (req.body.items != null) {
      invoice.items = req.body.items;
    }
    if (req.body.totalAmount != null) {
      invoice.totalAmount = req.body.totalAmount;
    }
    if (req.body.gstAmount != null) {
      invoice.gstAmount = req.body.gstAmount;
    }
    if (req.body.finalAmount != null) {
      invoice.finalAmount = req.body.finalAmount;
    }

    const updatedInvoice = await invoice.save();
    res.json(updatedInvoice);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Delete an invoice
router.delete('/:id', async (req, res) => {
  try {
    const invoice = await Invoice.findById(req.params.id);
    if (!invoice) {
      return res.status(404).json({ message: 'Invoice not found' });
    }

    await invoice.deleteOne();
    res.json({ message: 'Invoice deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router; 