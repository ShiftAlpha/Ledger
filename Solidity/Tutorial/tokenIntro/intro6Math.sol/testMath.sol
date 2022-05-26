//math and libraries
pragma solidity 0.5.11;

import "./Math.sol";


contract MyContract{

    //DRY - Dont repeat yourself
    //need to update the obtaining from library
    //import works however with solidity continuously updating - syntax changes occur
    //was writen in 0.5.8
    using safeMath for uint256;
    uint256 public value;
    function calculate(uint _value1, uint _value2) public{
        value = Math.divide(_value1,_value2);
    }
}