pragma solidity >=0.4.22 <0.6.0;

/// @title Voting with delegation
contract Ballot{
// This declares a new type representing single voter variables

    struct Voter {
        uint weight; // accumilated by delegation
        bool voted; // if true, user already voted
        address delegate; // person delegated to
        uint vote; // index of the voted proposal
    }

//
    struct Proposal {
        bytes32 name; // short name - up to 32bytes
        uint voteCount; // accumilated votes
    }

    address public chairperson;

//Delcares a state variable - stores 'Voter' struct for each
// possible address
    mapping(address => Voter) public voters;

// Array - size of proposal
    Proposal[] public proposals;

/// Creates a new ballot to choose one of 'proposalNames'
    constructor (bytes32[] memory ProposalNames) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

    // create a new proposal for each proposal names
        for (uint i = 0; i < ProposalNames.length;i++){
            proposals.push(Proposal({
                name: ProposalNames[i],
                voteCount: 0
            }));
        }
    }
    //Give voter the right to vote
    //Only called by chairperson
    function giveRightToVote(address voter) public {
        // If the first argument of `require` evaluates
        // to `false`, execution terminates and all
        // changes to the state and to Ether balances
        // are reverted.
        // This used to consume all gas in old EVM versions, but
        // not anymore.
        // It is often a good idea to use `require` to check if
        // functions are called correctly.
        // As a second argument, you can also provide an
        // explanation about what went wrong.
        require(msg.sender == chairperson, "Only chairperson can give right to vote");
        require(!voters[voter].voted,"The Voter already voted");
        require(voters[voter].weight == 0,"");
        voters[voter].weight = 1;
    }

    //Delegate voter to the voter 'to'
    function delegate(address to) public{
    address tempTo = to;
    //assigns ref
    Voter storage sender = voters[msg.sender];
    require(!sender.voted, "You already voted.");

    require(tempTo != msg.sender, "Self-delegation is disallowed.");
        // Forward the delegation as long as
        // `to` also delegated.
        // In general, such loops are very dangerous,
        // because if they run too long, they might
        // need more gas than is available in a block.
        // In this case, the delegation will not be executed,
        // but in other situations, such loops might
        // cause a contract to get "stuck" completely.
        while ( voters[to].delegate != address(0) &&
            voters[to].delegate != msg.sender){
            tempTo = voters[to].delegate;

        // We found a loop in the delegation, not allowed.
            require(to != msg.sender, "Found loop in delegation.");
        }

        //Since 'sender' is a reference, this
        // modifies 'voters[msg.sender]voted'
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if(delegate_.voted){
            //If the delegate already voted,
            //directly add to the number of votes
            proposals[delegate_.vote].voteCount += sender.weight;

        }else {
            //If the delegate did not vote yet,
            //add to her weight.
            delegate_.weight += sender.weight;
        }
    }
    ///Give your vote (including votes delegated to you)
    /// to proposal 'proposals[proposal].name'.
    function vote(uint proposal) public{
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0,"Has no right to vote");
        require(!sender.voted, "ALready voted.");
        sender.voted = true;
        sender.vote = proposal;

        //If 'proposal' is out of the range of the array
        //this will throw automatically and revert all changes
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev computes the winning proposal taking all
    /// previous votes into account.
    function winningProposal() public view returns (uint winningProposal_){
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    // Calls winningProposal() function to get the index
    // of the winner contained in the proposals array and then
    // returns the name of the winner
    function winnerName() public view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }

}
