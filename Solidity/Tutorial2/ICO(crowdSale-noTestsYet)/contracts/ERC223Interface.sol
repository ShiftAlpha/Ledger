pragma solidity ^0.5.11;
//interface of ERC223 token
interface ERC223 {
    //contains function/method of transfering to and from addresses(sender and receiver)
    function transfer(address _to, uint _value, bytes calldata _data) external returns (bool);
    //event of transfer of token
    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}
