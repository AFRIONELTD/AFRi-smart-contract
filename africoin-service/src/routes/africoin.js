const express = require('express');
const router = express.Router();
const africoinService = require('../services/africoinService');

// Mint tokens (admin only)
router.post('/mint', async (req, res) => {
  const { to, amount } = req.body;
  try {
    const tx = await africoinService.mint(to, amount);
    res.json({ txHash: tx.hash });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Add admin (owner only)
router.post('/add-admin', async (req, res) => {
  const { admin } = req.body;
  try {
    const tx = await africoinService.addAdmin(admin);
    res.json({ txHash: tx.hash });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Remove admin (owner only)
router.post('/remove-admin', async (req, res) => {
  const { admin } = req.body;
  try {
    const tx = await africoinService.removeAdmin(admin);
    res.json({ txHash: tx.hash });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Check if address is admin
router.get('/is-admin/:address', async (req, res) => {
  try {
    const isAdmin = await africoinService.isAdmin(req.params.address);
    res.json({ isAdmin });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Get balance
router.get('/balance/:address', async (req, res) => {
  try {
    const balance = await africoinService.getBalance(req.params.address);
    res.json({ balance: balance.toString() });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

module.exports = router; 