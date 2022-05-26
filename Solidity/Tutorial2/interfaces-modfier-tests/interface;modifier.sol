pragma solidity ^0.5.11;

//interface - regulator
interface Regulator {
    //function checkValue - uint var amount - returns boolean value
    function checkValue(uint amount) external returns (bool);
    //function loan - returns boolean value
    function loan() external returns (bool);
}
//contract implements regulator
contract Bank is Regulator {
    //uint private var - value
    uint private value;
    //address private var -owner
    address private owner;

    //modifier - function/method - modifies(mutator)
    modifier ownerFunc {
        //requires if owner equals sender
        require(owner == msg.sender,
         "Sender not authorized");
        _;
    }
    //constructor
    constructor(uint amount) public {
        //value assigned to amount var
        value = amount;
        //owner assigned to sender
        owner = msg.sender;
    }
    //function/method deposit
    function deposit(uint amount) public ownerFunc {
        //value  increases by amount
        //value = value + amount
        value += amount;
    }
    //function/method withdraw
    function withdraw(uint amount) public ownerFunc {
        if (checkValue(amount)) {
            //value decreases by amount var
            //value = value - amount
            value -= amount;
        }
    }
    //balance view
    function balance() public view returns (uint) {
        return value;
    }

    function checkValue(uint amount) public returns (bool) {
        //value always higher than amount
        return value >= amount;
    }

    function loan() public returns (bool) {
        return value > 0;
    }
}
//contract parses variables to bank contract
contract MyFirstContract is Bank(10) {
    string private name;
    uint private age;
    //set method/function - name
    function setName(string memory newName) public {
    //name is assigned to newName var
        name = newName;
    }
    //get method/function - name
    function getName() public view returns (string memory) {
        return name;
    }
    //set method/function - age
    function setAge(uint newAge) public {
        //age is assigned to newAge var
        age = newAge;
    }
    //get method/functionn - age
    function getAge() public view returns (uint) {
        return age;
    }
}

//testThrows contract
contract TestThrows {
    function testAssert() public pure {
        assert(1 == 2);
    }

    function testRequire() public pure {
        require(2 == 1,"");
    }

    function testRevert() public pure {
        revert("Error Message");
    }

    //throw is deprecated
    function testThrow() public pure {
        //use revert()
        //assert()
        //require

        //to remove error
        revert("");

        //throw;
    }
}
