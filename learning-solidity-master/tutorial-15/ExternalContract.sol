pragma solidity ^0.5.11;

contract ExternalContract {
    function externalCall(string calldata) external pure returns (uint) {
        return 123;
    }

    function publicCall(string memory) public pure returns (uint) {
        return 123;
    }
}