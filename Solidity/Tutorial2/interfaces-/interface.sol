pragma solidity ^0.5.11;

//interface - abstract
//1) Interfaces cannot have any functions implemented
//2) Interfaces cannot inherit other contracts or interfaces
//3) Interfaces cannot define a constructor
//4) Interfaces cannot define variables
//5) Interfaces cannot define structs
//6) Interfaces cannot define enums.
//7) Interfaces are expressed using the interface keyword.

// contains undefined functions with names and arguments
 interface Regulator {
    //check value amount method - returns boolean value
    function checkValue(uint amount) external returns (bool);
    //function method loan - returns boolean value
    function loan() external returns (bool);
}
// parses through to interface
// you are forced to have matching functions with definition
contract Bank is Regulator {
    //u-integer value is private
    uint private value;

    //constructor - value is set to amount uint var - public
    constructor(uint amount) public {
        value = amount;
    }
    //function deposit - deposit amount - value increases by amount
    function deposit(uint amount) public {
        //value = value + amount
        value += amount;
    }
    // function withdraw - withdraw amount variable from value - value decrease by amount
    function withdraw(uint amount) public {
        //calls checkValue method - contains amount - then
        if (checkValue(amount)) {
            //value = value - amount
            value -= amount;
        }
    }
    //function balance - value to be viewed - u-integer value
    function balance() public view returns (uint amount) {
        //returns value
        return value;
    }
    //function to check the value - uint amount - returns boolean var
    function checkValue(uint amount) public returns (bool) {
        //value must be higher than amount
        return value >= amount;
    }
    //function loan - returns boolean value
    function loan() public returns (bool) {
        //greater than 0 - must
        return value > 0;
    }
}

//name of contract - MyFirstContract
//parses values to bank contract
contract MyFirstContract is Bank(10) {
    //string private var - name
    string private name;
    //u-integer private var - age
    uint private age;

    //setName function/method - setter
    function setName(string memory newName) public {
        //name var is assigned to newName var
        name = newName;
    }
    //getName function/method - getter
    function getName() public view returns (string memory) {
        return name;
    }
    //setAge method - setter
    function setAge(uint newAge) public {
        //age var is assigned to newAge var
        age = newAge;
    }
    //getAge function/method - getter
    function getAge() public view returns (uint) {
        return age;
    }
}
