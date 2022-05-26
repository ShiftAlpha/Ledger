pragma solidity ^0.5.11;

// contract transactions
contract Transaction {

    //events
    //event - sender logger - checks/outputs sender address
    event SenderLogger(address);
    //event - value logger - checks/outputs value
    event ValueLogger(uint);

    //address privarte var - owener
    address private owner;

    //modifier - isOwner
    modifier isOwner {
        require(owner == msg.sender,"");
        _;
    }

    //modifier validValue
    modifier validValue {
        assert(msg.value >= 1 ether);
        _;
    }
    constructor() public {
        owner = msg.sender;
    }
    //function/method checks owners valid value
    function () external payable isOwner validValue {
        //outputs owner/sender
        emit SenderLogger(msg.sender);
        //outputs value sender is sendind/transacting
        emit ValueLogger(msg.value);
    }
}
