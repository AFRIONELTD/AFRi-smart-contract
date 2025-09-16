AFRICOIN CONTRACT_ETH  = https://sepolia.etherscan.io/address/0x10111032B1Cd4151AEFA0b41627e4F693f5183FF#code
AFRICOIN CONTRACT _TRON  = https://shasta.tronscan.org/#/contract/TSXL4QQqQRCUsZgCRFF4Vw4Hj4cTNndMXy/code

41b59536fb54338085e1b51d7fa8f7f8b33ce31401

TRON(SHASTA)=TSXL4QQqQRCUsZgCRFF4Vw4Hj4cTNndMXy
ETH(SEPOLIA)=0x10111032B1Cd4151AEFA0b41627e4F693f5183FF


- name orivate key well
- when we are calloing the mint function we are passing the  the privateKey stoed in the env.. we shiuld be passing the pk of the admin

export RPC_URL="https://eth-mainnet.g.alchemy.com/v2/tyvENgunVTriqd_lrUMyi2MkZ4sdkyAf"
export PRIVATE_KEY="0x716a0bf282873fb08c1ad03453e2b3208970bb429082807950070d68e0590ec2"
export OWNER_ADDRESS="0xeB9260c4d058Eb5B9E4b01bbB038045cf794E363"

forge script script/DeployAfricoin.s.sol:DeployAFRi \
  --rpc-url $RPC_URL \
  --broadcast \
  --private-key $PRIVATE_KEY \
  -vvvv


export ETHERSCAN_API_KEY=<VMWQ8FFS7NDEAFW5QFFHMX41VRNINJNC95>
export RPC_URL="https://eth-mainnet.g.alchemy.com/v2/tyvENgunVTriqd_lrUMyi2MkZ4sdkyAf"    
export CHAIN_ID=1                                
export DEPLOYED_ADDRESS=0x5f35d07A1c053b9eA6021A16E2cB8d925f093d2B
export OWNER_ADDRESS=0xeB9260c4d058Eb5B9E4b01bbB038045cf794E363                   




export ETHERSCAN_API_KEY=<VMWQ8FFS7NDEAFW5QFFHMX41VRNINJNC95>
export RPC_URL="https://eth-mainnet.g.alchemy.com/v2/tyvENgunVTriqd_lrUMyi2MkZ4sdkyAf"    
export CHAIN_ID=1                                
export DEPLOYED_ADDRESS=0x5f35d07A1c053b9eA6021A16E2cB8d925f093d2B
export OWNER_ADDRESS=0xeB9260c4d058Eb5B9E4b01bbB038045cf794E363  

forge verify-contract \
  --chain-id $CHAIN_ID \
  --verifier etherscan \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  $DEPLOYED_ADDRESS \
  src/Africoin.sol:AFRi \
  --constructor-args $(cast abi-encode "constructor(address)" $OWNER_ADDRESS) \
  --watch

