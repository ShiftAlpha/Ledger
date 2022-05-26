const SHA256 = require('crypto-js/sha256');
const EC = require('elliptic').ec;
const ec = new EC('secp256k1');

//transaction
class Transaction {
    constructor(fromAddress, toAddress, amount) {
        this.fromAddress = fromAddress;
        this.toAddress = toAddress;
        this.amount = amount;
    }

    calculateHash(){
        return SHA256(this.fromAddress + this.toAddress + this.amount).toString();
    }

    signTransaction(signingKey){
        if(signingKey.getPublic('hex') !== this.fromAddress){
            throw new Error('You cannot sign transactions for other wallets!');
        }

        const hashTx = this.calculateHash();
        const sig  = signingKey.sign(hashTx, 'base64');
        this.signature = sig.toDER('hex');
    }

    //checks if valid
    isValid(){
        if(this.fromAddress === null)
        return true;

        if(!this.signature || this.signature.length === 0){
            throw new Error('No signature in this transaction');
        }

        const publicKey = ec.keyFromPublic(this.fromAddress, 'hex');
        return publicKey.verify(this.calculateHash(), this.signature);
    }
}


//block class
class Block {
    constructor(timestamp, transactions, previousHash = '') {

        this.timestamp = timestamp; //timestamp - when the block was created 
        this.transactions = transactions; //transactions - details of currency transaction
        this.previousHash = previousHash; //previousHash- string that contains previous hash of block
        this.hash = this.calculateHash(); // contain hash of current block
        this.nonce = 0;
    }

    //calculates Hash
    calculateHash() {
        return SHA256(this.index + this.previousHash + this.timestamp + JSON.stringify(this.transactions) + this.nonce).toString();
    }

    //valid check
    mineBlock(difficulty) {
        while (this.hash.substring(0, difficulty) !== Array(difficulty + 1).join("0")) {
            this.nonce++;
            this.hash = this.calculateHash();
        }
        console.log("Block mined: " + this.hash);
    }

    hasValidTransaction(){
        for(const tx of this.transactions){
            if(!tx.isValid()){
                return false;
            }
        }
        return true;
    }
}

//blockchain class
class Blockchain {
    constructor() {
        this.chain = [this.createGenisisBlock()];
        this.difficulty = 2;
        this.pendingTransactions = [];
        this.miningReward = 100;

    }

    //creates genisis block
    createGenisisBlock() {
        return new Block("01/01/2019", "Genisis Block", "0");
    }

    //gets latest block
    getLatestBLock() {
        return this.chain[this.chain.length - 1]
    }
    //mining rewards
    minePendingTransactions(miningRewardAddress) {
        let block = new Block(Date.now(), this.pendingTransactions);
        block.mineBlock(this.difficulty);

        console.log('Block successfully mined');
        this.chain.push(block);

        this.pendingTransactions = [new Transaction(null, miningRewardAddressm, this.miningReward)];
    }
    
    addTransaction(transaction){

        if(!transaction.fromAddress || !transaction.toAddress){
            throw new Error('Transaction must include from and to address');
        }

        if(!transaction.isValid()){
            throw new Error('Cannot add invalid transaction to chain');
        }
        this.pendingTransactions.push(transaction);
    }

    getBalanceOfAddress(address){
        let balance =0;
        
        for(const block of this.chain){
            for(const trans of block.transaction){
                if(trans.fromAddress === address){
                    balance -= trans.amount;

                }
                if(trans.address === address){
                    balance += trans.amount;
                }
            }
        }
        return balance;
    }

    // tests integrity of blockchain
    isChainValid() {
        //gen block is 1 - loop till end 
        for (let i = 1; i < this.chain.length; i++) {
            const currentBlock = this.chain[i];
            const previousBlock = this.chain[i - 1];

            if(!currentBlock.hasValidTransaction()){
                return false;
            }

            if (currentBlock.hash !== currentBlock.calculateHash()) {
                return false;
            }
            if (currentBlock.previousHash !== previousBlock.hash) {
                return false;
            }
        }
        return true;
    }
}

module.exports.Blockchain = Blockchain;
module.exports.Transaction = Transaction;
