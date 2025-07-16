const { ethers } = require('ethers');
const provider = require('../config/provider');
require('dotenv').config();

// TODO: Replace with actual Africoin ABI
const AFRICOIN_ABI = [
  // Minimal ABI for demonstration
  "function mint(address to, uint256 amount) public",
  "function addAdmin(address admin) public",
  "function removeAdmin(address admin) public",
  "function isAdmin(address admin) public view returns (bool)",
  "function balanceOf(address account) public view returns (uint256)"
];

const contractAddress = process.env.CONTRACT_ADDRESS;
const privateKey = process.env.PRIVATE_KEY;

const wallet = new ethers.Wallet(privateKey, provider);
const africoin = new ethers.Contract(contractAddress, AFRICOIN_ABI, wallet);

async function mint(to, amount) {
  return africoin.mint(to, amount);
}

async function addAdmin(admin) {
  return africoin.addAdmin(admin);
}

async function removeAdmin(admin) {
  return africoin.removeAdmin(admin);
}

async function isAdmin(admin) {
  return africoin.isAdmin(admin);
}

async function getBalance(address) {
  return africoin.balanceOf(address);
}

module.exports = {
  mint,
  addAdmin,
  removeAdmin,
  isAdmin,
  getBalance,
}; 