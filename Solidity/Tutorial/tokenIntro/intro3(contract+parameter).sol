pragma solidity 0.5.11;

contract myContract {
    uint256 public peopleCount = 0;
    //associative array
    mapping(uint => Person) public people;

    //address owner;

    /*modifier onlyOwner() {
        require(msg.sender == owner, "Error");
        _;
    }*/

    uint256 openingTime;
    modifier onlyWhileOpen() {
        //parameter
        require(block.timestamp >= openingTime,"Error");
        _;
            }

    struct Person {
        //attributes of struct person
        uint _id;
        string _firstName;
        string _lastName;
    }

    /*constructor() public {
        owner = msg.sender;
    }*/


    //Add to an array
    function addPerson(string memory _firstName, string memory _lastName) public onlyWhileOpen{
        //peopleCount += 1;
        incrementCount();
        people[peopleCount] = Person(peopleCount, _firstName, _lastName);
    }
    function incrementCount() internal {
        peopleCount += 1;
    }
}