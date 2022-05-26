pragma solidity ^0.5.11;

//contract named migrations to migrate to the blockchain
contract Migrations {
    //address var owner - made public
  address public owner;
    //u-integer var last_com_mi - public
  uint public last_completed_migration;

    //modifier to check if the sender is owener
  modifier restricted() {
    if (msg.sender == owner) _;
  }

  constructor() public {
    owner = msg.sender;
  }
    //function/method to set completed previous migration
  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
  //function/method to upgrade migration to a new address
  function upgrade(address new_address) public restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}