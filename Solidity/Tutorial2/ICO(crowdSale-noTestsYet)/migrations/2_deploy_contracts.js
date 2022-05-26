//migrations to migrate all contracts to the blockchain in order for contracts to work
//BC = BlockChain (use test like metamask or ganache cli)
//variables assigned to the imports required
var SafeMathLib = artifacts.require("./SafeMathLib.sol");
var MyTokenCon = artifacts.require("./MyTokenContract.sol");
var AddressesLib = artifacts.require("./AddressesLib.sol");
var CrowdSaleCon = artifacts.require("./ICOCrowdSaleContract.sol");
//modules being exported 
//depolyer to deploy contracts
//link to link contracts with libraries
module.exports = function(deployer) {
  //deploys math library to BC
  deployer.deploy(SafeMathLib);
  //deplos to BC and links math library to token contract
  deployer.link(SafeMathLib, MyTokenCon);
  //deploys address library to BC
  deployer.deploy(AddressesLib);
  //links address library to token contract and deploys to BC
  deployer.link(AddressesLib, MyTokenCon);
  //deploys my token to BC 
  deployer.deploy(MyToken).then(function(){
    return deployer.deploy(
      CrowdSaleCon,
      MyTokenCon.address,
      web3.eth.blockNumber,
      web3.eth.blockNumber+1000,
      web3.toWei(1, 'ether'),
      1
    ).then(function(){});
  });
};
