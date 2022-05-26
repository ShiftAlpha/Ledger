pragma solidity ^0.5.11;

//library to be imported - IntExtended
library IntExtended {
    //function/method to increment by base
    //self++
    function increment(uint _self) public pure returns (uint) {
        return _self+1;
    }
    //function/method to decrement by base
    //self--
    function decrement(uint _self) public pure returns (uint) {
        return _self-1;
    }
    //function/method to increment base by value
    //self = self + value
    function incrementByValue(uint _self, uint _value) public pure returns (uint) {
        return _self + _value;
    }
    //function/method to decrement base by value
    //self = self - value
    function decrementByValue(uint _self, uint _value) public pure returns (uint) {
        return _self - _value;
    }
}
