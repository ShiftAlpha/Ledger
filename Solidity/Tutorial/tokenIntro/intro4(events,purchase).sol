pragma solidity 0.5.11;

//contract with event of purchasing

contract MyContract{
    //address of u-int 256 bytes is set to a public var - balances
    mapping(address => uint256)public balances;
    //payable ref to the address being payable
    address payable wallet;

//event - purchase
    event Purchase(
        //requires attributes of who is purchasing and amount
        //**product in other tuts**
        address /**Specific*/indexed _buyer,
        uint256 _amount
    );

    constructor(address payable _wallet)public{
        //wallet assigned to _wallet
        wallet = _wallet;
    }

    //Buy externally
    function() external payable{
        buyToken();
    }
    //function/method to purchase token
    function buyToken() public payable{
        // buy a token
        balances[msg.sender] += 1;
        //send ether to the wallet
        wallet.transfer(msg.value);
        //emit class - to log event
        emit Purchase(msg.sender,1);
        }
}