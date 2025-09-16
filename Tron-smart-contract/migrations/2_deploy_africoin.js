const AFRi = artifacts.require("AFRi");

module.exports = function (deployer, network, accounts) {
  // 1,000,000 tokens with 18 decimals
  const initialSupply = "1000000000000000000000000";
  const owner = process.env.OWNER_ADDRESS || accounts[0]; // Use environment variable or first account as owner
  deployer.deploy(AFRi, owner);
};