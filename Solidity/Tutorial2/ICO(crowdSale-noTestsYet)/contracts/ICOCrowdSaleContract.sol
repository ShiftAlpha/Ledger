pragma solidity ^0.5.11;
//imports of sol contracts and libraries
import "./ERC223ReceivingContract.sol";
import "./SafeMathLib.sol";
import "./ERC20Interface.sol";
import "./TokenContract.sol";

//contract to sell an ICO to the public
//raise funds for capital of a coin

contract Crowdsale is ERC223ReceivingContract {

//calls safemath from import/sol contract safemath library to use with unit
  using SafeMath for uint;

  //calls token and creates new token from sol smart contract
  //with all attributes of token
  Token private _token;

  //variables declared privated
  uint private _start;
  uint private _end;

  uint private _price;
  uint private _limit;
  uint private _available;

  mapping (address => uint) private _limits;
  //event to buy - attributes used - beneficiery address and u-integer amount
  event Buy(address beneficiary, uint amount);
  //if available
  modifier available() {
    //requires amount to be above 0 , custome error message to be input
    require(_available > 0,"");
    //requires the start and end block number
    require(block.number >= _start && block.number < _end,"");
    _;
  }
  //if token
  modifier isToken() {
    //requires owner is the address of the token, with error message
    require(msg.sender == address(_token),"");
    _;
  }
  //if valid
  modifier valid(address to, uint amount) {
    assert(amount > 0);
    amount = amount.div(_price);
    assert(_limit >= amount);
    assert(_limit >= _limits[to].add(amount));
    _;
  }
//constructor with variables parsed
  constructor(address token, uint start, uint end, uint price, uint limit)public {
      _token = Token(token);
      _start = start;
      _end = end;
      _price = price;
      _limit = limit;
  }

  function ()external payable {
      // Not enough gas for the transaction so prevent users from sending ether
      revert("Error");
  }
//general functions of purchase
  function buy() public payable {
      return buyFor(msg.sender);
  }

  function buyFor(address beneficiary) public available valid(beneficiary, msg.value) payable {
      uint amount = msg.value.div(_price);
      _token.transfer(beneficiary, amount);
      _available = _available.sub(amount);
      _limits[beneficiary] = _limits[beneficiary].add(amount);
      //push buy event
       emit Buy(beneficiary, amount);
  }

  function tokenFallback(address, uint _value, bytes memory) public isToken {
      _available = _available.add(_value);
  }

  function availableBalance()public view returns (uint) {
    return _available;
  }
}
