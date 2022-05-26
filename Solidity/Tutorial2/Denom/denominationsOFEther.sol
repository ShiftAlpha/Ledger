pragma solidity ^0.5.11;

//contract showing all denoms in ether and wei
//(currency on blockchain)
//how gas is calculated through what weight of ether
contract Denominations {
    // WEI Denominations
    uint constant WEI = 1 wei;
    uint constant KWEI = 1000 wei;
    uint constant MWEI = 1000000 wei;
    uint constant GWEI = 1000000000 wei;

    // Ether Denominations
    uint constant MICROETHER = 1 szabo;
    uint constant MILLIETHER = 1 finney;
    uint constant ETHER = 1 ether;
    uint constant KETHER = 1000 ether;
    uint constant METHER = 1000000 ether;
    uint constant GETHER = 1000000000 ether;
    uint constant TETHER = 1000000000000 ether;
}
