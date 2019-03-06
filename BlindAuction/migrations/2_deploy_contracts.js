var BlindAuction = artifacts.require('./BlindAuction.sol');

module.exports = function(deployer) {
    deployer.deploy(BlindAuction, '0xa988cf1fae1275fdacf1d5bdf591c2eb57e3e8e1', 500, 200);
}
