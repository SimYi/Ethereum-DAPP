var SimpleAuction = artifacts.require("./SimpleAuction.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(SimpleAuction, 2000000000000, accounts[0]);
};
