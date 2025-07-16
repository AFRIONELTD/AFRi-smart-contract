const AfriCoin = artifacts.require("AfriCoin");

module.exports = function (deployer) {
  // 1,000,000 tokens with 18 decimals
  const initialSupply = "1000000000000000000000000";
  deployer.deploy(AfriCoin, initialSupply);
};