pragma solidity ^0.5.11;

//first contract/class
contract MyFirstContract {
    //string variable name
    string private name;
    //u-integer age;
    uint private age;

    //set function/method - name
    function setName(string memory newName) public {
        name = newName;
    }
    //get function/method - name
    function getName() public view returns (string memory ) {
        return name;
    }
    //set function/method - age
    function setAge(uint newAge) public {
        age = newAge;
    }
    //get function/method - age
    function getAge() public view returns (uint) {
        return age;
    }
}
