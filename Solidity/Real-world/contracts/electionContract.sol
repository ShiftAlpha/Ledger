pragma solidity 0.5.11;

//contract named election
contract Election {

    // Model a Candidate
    //attributes a candidate will have
    struct Candidate {
        //variables/attributes of candidate
        uint id;
        string name;
        uint voteCount;
    }

    // Store accounts that have voted
    mapping(address => bool) public voters;
    // Store Candidates
    // Fetch Candidate
    mapping(uint => Candidate) public candidates;
    // Store Candidates Count
    uint public candidatesCount;

    // voted event
    event votedEvent (
        //u-integer var indexed is stored as _candidateID
        uint indexed _candidateId
    );

    constructor() public {
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
    }
    //function/method to add candidate
    function addCandidate (string memory _name) private {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }
    //fucntion/method to vote
    function vote (uint _candidateId) public {
        // require that they haven't voted before
        // Error message must be changed to refer to require class
        require(!voters[msg.sender],"Error");

        // require a valid candidate
        // Error message must be changed to refer to require class
        require(_candidateId > 0 && _candidateId <= candidatesCount,"Error");

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;

        // trigger voted event
        emit votedEvent(_candidateId);
    }
}