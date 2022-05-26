pragma solidity ^0.5.11;

//contract token
//creating a general token and attributes
// name,symbol,total supply available,balance

contract Token {
    //variables of token
    string internal _symbol;
    string internal _name;
    //integer of 8 bytes - named _decimals
    uint8 internal _decimals;
    //the amount of tokens availble for purchase
    uint internal _totalSupply;

    mapping (address => uint) internal _balanceOf;
    mapping (address => mapping (address => uint)) internal _allowances;

    //constructor parsing all variables
    constructor(string memory symbol, string memory name, uint8 decimals, uint totalSupply) public {
        _symbol = symbol;
        _name = name;
        _decimals = decimals;
        _totalSupply = totalSupply;
    }
    //general methods
    function name()public view returns (string memory) {
        return _name;
    }

    function symbol()public view returns (string memory) {
        return _symbol;
    }

    function decimals()public view returns (uint8) {
        return _decimals;
    }

    function totalSupply()public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address _addr) public view returns (uint);
    function transfer(address _to, uint _value) public returns (bool);
    //event to transfer from address(sender) to address(receiver)
    event Transfer(address indexed _from, address indexed _to, uint _value);
}
