pragma solidity ^0.5.11;


//types of data on solidity
//strings bool bytes addresses

//obtaining balances
//actions : add remove update
contract DataTypes {

    bool myBool = false;

    int8 myInt = -128;
    uint8 myUInt = 255;

    string myString;
    uint8[] myStringArr;

    byte myValue;
    bytes1 myBytes1;
    bytes32 myBytes32;

//    fixed256x8 myFixed = 1; // 255.0
//    ufixed myFixed = 1;

    enum Action {ADD, REMOVE, UPDATE}

    Action myAction = Action.ADD;

    address payable myAddress;
//function/method to assign address to an owner/sender
//with transfer
    function assignAddress() public {
        myAddress = msg.sender;
        myAddress.balance;
        myAddress.transfer(10);
    }

    uint[] myIntArr = [1,2,3];
//using arrays 
    function arrFunc() public {
        myIntArr.push(1);
        myIntArr.length;
        myIntArr[0];
    }

    uint[10] myFixedArr;
//struct containing balance nd daily limit variables
//struct - attributes of account with be variables declared in brackets
    struct Account {
        uint balance;
        uint dailyLimit;
    }
//acount reates an object myAccount with above struct attibutes
    Account myAccount;
//function/method to get balance
    function structFunc() public {
        myAccount.balance = 100;
    }
//allocates address of account to _accounts to be re-used
    mapping (address => Account) _accounts;

    function () external payable {
        _accounts[msg.sender].balance += msg.value;
    }
//gets balance of owner/sender-accounts
    function getBalance() public view returns (uint) {
        return _accounts[msg.sender].balance;
    }
}
