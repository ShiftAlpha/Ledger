pragma solidity ^0.5.11;
//contract for migrating to the blockchain
contract Migrations {
  address public owner;
  uint public last_completed_migration;
  //checks if sender is owner
  modifier restricted() {
    if (msg.sender == owner) _;
  }

  constructor() public {
    owner = msg.sender;
  }
//set function/method
  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
//upgrade function/method to upgrade to a new migration
//sets new address
  function upgrade(address new_address) public restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}
