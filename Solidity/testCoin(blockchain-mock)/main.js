const {Blockchain, Transaction} = require('./blockchain');

const EC = require('elliptic').ec;
const ec = new EC('secp256k1');

const myKey = ec.keyFromPrivate('#');
const myWallet = myKey.getPublic('hex');

let testCoin = new Blockchain();

const tx1 = new Transaction(myWalletAddress, 'public key goes here','num coins');
tx1.signTransaction(myKey);
testCoin.addTransaction(tx1);


console.log('\n Starting the miner...');
testCoin.minePendingTransactions(myWalletAddress);

console.log('\n Balance of his is ', testCoin.getBalanceOfAddress(myWalletAddress));




