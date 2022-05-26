pragma solidity 0.5.11;

contract myContract{
    /*
    Datatypes
    string public constant stringValue = "myValue" ;
    bool public myBool = true;
    int public myInt = -1;
    uint public myUint = 1;
    uint8 public myUint8 = 8;
    uint256 public myUint256 = 99999;

    Enum:
    enum State {Waiting, Ready, Active}
    State public state;
    constructor() public {
        state = State.Waiting;
    }
    function activate() public {
        state = State.Active;
    }
    function isActive() public view returns(bool){
        return state == state.Active
    }*/

    /*Add to an array
    Person[] public people;
    uint256 public peopleCount;
        struct Person {
        string _firstName;
        string _lastName;
    }
    function addPerson(string memory _firstName, string memory_lastName) public {
        people.push(person(_firstName, _lastName));
        peopleCount += 1;
    }
    */


    uint256 public peopleCount = 0;
    //associative array
    mapping(uint => Person) public people;

    //struct is attribute class that can create an object
    struct Person {
        //attributes to person
        uint _id;
        string _firstName;
        string _lastName;
    }

    //Add to an array
    function addPerson(string memory _firstName, string memory _lastName) public{
        //increment
        peopleCount += 1;
        //index of people obj at peopleCount index
        //assigns new fName and sName to another person
        //another way of a for loop having attributes wrriten to each index of person obj
        people[peopleCount] = Person(peopleCount, _firstName, _lastName);
    }
}
