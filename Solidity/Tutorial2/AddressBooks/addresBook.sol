pragma solidity ^0.5.11;

// A smart contract written to obtain addresses

// add address
//delete address
//get alias of address

contract AddressBook {
    mapping(address => address[]) private _addresses;
    mapping(address => mapping(address => string)) private _aliases;

//get address
    function getAddresses() public view returns (address[]memory) {
        return _addresses[msg.sender];
    }
//add address
    function addAddress(address addr, string memory aliase) public {
        _addresses[msg.sender].push(addr);
        _aliases[msg.sender][addr] = aliase;
    }

//delete/remove address
    function removeAddress(address addr) public {
        uint length = _addresses[msg.sender].length;
        for(uint i = 0; i < length; i++) {
            if (addr == _addresses[msg.sender][i]) {
                if (1 < _addresses[msg.sender].length && i < length-1) {
                    _addresses[msg.sender][i] = _addresses[msg.sender][length-1];
                }
                delete _addresses[msg.sender][length-1];
                _addresses[msg.sender].length--;
                delete _aliases[msg.sender][addr];
                break;
            }
        }
    }
//get alias of address
    function getAlias(address addr) public view returns (string memory) {
        return _aliases[msg.sender][addr];
    }
}
