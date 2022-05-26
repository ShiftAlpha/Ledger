pragma solidity ^0.5.11;

//imports library.sol from folder
import "./library.sol";

//contract TestLibrary
contract TestLibrary {
    //uses contract intExtended for uint variables
    //requires import - see below version compiler init
    using IntExtended for uint;
    //function/method to increase by increment base - variable uint _base
    //base++
    function testIncrement(uint _base) public pure returns (uint) {
        return IntExtended.increment(_base);
    }

    //function/method to increase by decrement amount - variable uint _base
    //base--
    function testDecrement(uint _base) public pure returns (uint) {
        return IntExtended.decrement(_base);
    }

    //function/method to increase by increment value - variable uint _base
    //base+=value
    function testIncrementByValue(uint _base, uint _value) public pure returns (uint) {
        return _base.incrementByValue(_value);
    }

    //function/method to increase by decrement value - variable uint _base
    //base-=value
    function testDecrementByValue(uint _base, uint _value) public pure returns (uint) {
        return _base.decrementByValue(_value);
    }
}
