pragma solidity ^0.5.11;

contract EtherTransferTo {
    function () external payable {
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract EtherTransferFrom {

    EtherTransferTo private _instance;

    constructor () public {
        // _instance = EtherTransferTo(address(this));
        _instance = new EtherTransferTo();
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getBalanceOfInstance() public view returns (uint) {
        //return address(_instance).balance;
        return _instance.getBalance();
    }

    function () external payable {
        //msg.sender.send(msg.value);
        address(_instance).transfer(msg.value);
    }
}