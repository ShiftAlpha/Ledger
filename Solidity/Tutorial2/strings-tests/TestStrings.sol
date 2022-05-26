pragma solidity ^0.5.11;

//imports library strings
import "./Strings.sol";

contract TestStrings {

    using Strings for string;

    //to test concat
    function testConcat(string memory _base) public pure returns (string memory) {
        return _base.concat("_suffix");
    }
    //find string
    function findString(string memory _base) public pure returns (int) {
        return _base.strpos("t");
    }
}
