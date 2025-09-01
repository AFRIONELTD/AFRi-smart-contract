require('dotenv').config();
const fs = require('fs');
const path = require('path');
const TronWeb = require('tronweb');

(async () => {
  const fullHost = process.env.FULL_HOST || 'https://api.trongrid.io';
  const privateKey = process.env.PRIVATE_KEY_MAINNET;
  const ownerAddress = process.env.OWNER_ADDRESS; // base58, e.g., TGRj...
  const feeLimit = Number(process.env.FEE_LIMIT || 1000000000); // 1,000 TRX in sun (reasonable)
  const originEnergyLimit = Number(process.env.ORIGIN_ENERGY_LIMIT || 20000000); // 20M Energy
  const consumeUserResourcePercent = Number(process.env.CONSUME_USER_RESOURCE_PERCENT || 0); // 0 = deployer pays all

  if (!privateKey) throw new Error('Missing PRIVATE_KEY_MAINNET');
  if (!ownerAddress) throw new Error('Missing OWNER_ADDRESS');

  const tronWeb = new TronWeb({ fullHost, privateKey });

  const artifactPath = path.join(__dirname, '..', 'build', 'contracts', 'AfriCoin.json');
  const artifact = JSON.parse(fs.readFileSync(artifactPath, 'utf8'));
  const { abi, bytecode } = artifact;

  const deployerAddress = tronWeb.address.fromPrivateKey(privateKey);
  console.log('Network:', fullHost);
  console.log('Deployer (from PK):', deployerAddress);
  console.log('Owner (constructor arg):', ownerAddress);
  console.log('Fee limit (sun):', feeLimit);
  console.log('Origin energy limit:', originEnergyLimit);
  console.log('Consume user resource %:', consumeUserResourcePercent);
  console.log('Energy sharing: Deployer pays', consumeUserResourcePercent === 0 ? '100%' : `${100 - consumeUserResourcePercent}%`);

  const contract = await tronWeb.contract().new({
    abi,
    bytecode,
    feeLimit,
    callValue: 0,
    userFeePercentage: consumeUserResourcePercent,
    originEnergyLimit,
    parameters: [ownerAddress]
  });

  console.log('AfriCoin deployed at:', contract.address);
})().catch((err) => {
  console.error('Deployment failed:', err);
  process.exit(1);
}); 