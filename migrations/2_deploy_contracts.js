const supplychain = artifacts.require("Supplychain");
module.exports = function (deployer) {
  deployer.deploy(supplychain);
};