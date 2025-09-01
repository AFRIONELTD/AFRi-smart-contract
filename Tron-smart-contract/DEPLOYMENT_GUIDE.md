# Tron Mainnet Deployment Guide

## Energy Sharing Configuration

Based on Tron's Contract Energy Sharing Mechanism, we've configured the deployment to use:
- `consume_user_resource_percent: 0` - Deployer pays 100% of energy costs
- `userFeePercentage: 0` - Same as above
- `feeLimit: 1,000,000,000 sun` (1,000 TRX) - Reasonable limit
- `originEnergyLimit: 20,000,000` - 20M Energy per transaction

## Deployment Options

### Option 1: TronBox Migration (Recommended)
```bash
cd "/Users/macbook/Desktop/Afrione /AFRICOIN/africoin-smart-contract/Tron-smart-contract"

# Set environment variables
export PRIVATE_KEY_MAINNET=YOUR_TRON_PRIVATE_KEY_HEX
export OWNER_ADDRESS=TGRjPm9CSq4kC2zzqPdaqBXHdrRQ2iT1Fw

# Compile and deploy
tronbox compile
tronbox migrate --network mainnet
```

### Option 2: Direct TronWeb Deployment
```bash
cd "/Users/macbook/Desktop/Afrione /AFRICOIN/africoin-smart-contract/Tron-smart-contract"

# Install dependencies
npm install

# Set environment variables
export PRIVATE_KEY_MAINNET=YOUR_TRON_PRIVATE_KEY_HEX
export OWNER_ADDRESS=TGRjPm9CSq4kC2zzqPdaqBXHdrRQ2iT1Fw

# Optional overrides
export FEE_LIMIT=1000000000         # 1,000 TRX in sun
export ORIGIN_ENERGY_LIMIT=20000000 # 20M Energy
export CONSUME_USER_RESOURCE_PERCENT=0 # Deployer pays all

# Build and deploy
tronbox compile
npm run deploy:tronweb
```

## Energy Requirements

### Minimum Requirements
- **Deployer Energy**: 20M+ Energy available
- **Deployer TRX**: 1,000+ TRX for feeLimit buffer

### How to Get Energy
1. **Stake TRX for Energy** (Recommended):
   - In TronLink, go to Resources → Stake for Energy
   - Stake ~20k-30k TRX to get ~20M+ Energy
   - This is more cost-effective than burning TRX

2. **Burn TRX for Energy**:
   - Set `FEE_LIMIT=1000000000` (1,000 TRX)
   - Ensure deployer has sufficient TRX balance

## Verification

After deployment, verify on TronScan:
1. Go to https://tronscan.org
2. Search for your contract address
3. Click "Verify Contract"
4. Upload `contracts/AfriCoin.sol`
5. Set compiler version: 0.8.6
6. Enable optimization: Yes (runs: 200)
7. Constructor argument: `TGRjPm9CSq4kC2zzqPdaqBXHdrRQ2iT1Fw`

## Troubleshooting

### OUT_OF_ENERGY Error
- Increase `originEnergyLimit` in deployment
- Ensure deployer has sufficient Energy
- Check if `consume_user_resource_percent` is set correctly

### BANDWIDTH_ERROR
- Deployer needs Bandwidth or TRX for Bandwidth
- Set higher `feeLimit` to cover Bandwidth costs

### Resource Insufficient
- Stake more TRX for Energy/Bandwidth
- Or increase `feeLimit` to burn more TRX 