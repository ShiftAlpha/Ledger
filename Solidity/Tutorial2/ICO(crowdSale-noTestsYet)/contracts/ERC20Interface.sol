pragma solidity ^0.5.11;
//interface of ER20 token
interface ERC20 {
    //contains all functions from MyToken
    //transferFrom method/function to transfer from address(sender) to address(receiver)
    function transferFrom(address _from, address _to, uint _value) external returns (bool);
    //function/method approved
    function approve(address _spender, uint _value) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint);
    //event approval from MyToken.sol
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}
