pragma solidity 0.5.11;

//basic contract showing how to set and get variables
//contains constructor

contract MyContract {
    string value;

    constructor() public{
        value = "myValue";
    }
    //get function/method
    function get() public view returns(string memory){
        return value;
    }
    //set function/method
    function set(string memory _value) public {
        value = _value;
    }
    /*string public value = "myValue";*/

}
