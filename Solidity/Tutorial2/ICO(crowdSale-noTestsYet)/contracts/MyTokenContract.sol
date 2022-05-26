pragma solidity ^0.5.11;

import "./TokenContract.sol";
import "./ERC20Interface.sol";
import "./ERC223Interface.sol";
import "./ERC223ReceivingContract.sol";
import "./SafeMathLib.sol";
import "./AddressesLib.sol";

//contract test of tokens
//preset variables for input of token
contract MyToken is Token("MFT", "My Token", 0, 10000), ERC20, ERC223 {
    //using from libraries - imports above
    using SafeMath for uint;
    using Addresses for address;
    //constructor
    constructor() public {
        //balance of owner - assigned to total supply
        _balanceOf[msg.sender] = _totalSupply;
    }
    //function/method of total supply
    function totalSupply()public view returns (uint) {
        return _totalSupply;
    }
    //function/method of balance of  address- owner
    function balanceOf(address _addr)public view returns (uint) {
        return _balanceOf[_addr];
    }
    //function/method of transfer from address(owner)
    function transfer(address _to, uint _value)public returns (bool) {
        return transfer(_to, _value, "");
    }
    //function/method of transfer from address(owner) to address(sender)

    function transfer(address _to, uint _value, bytes memory _data)public returns (bool) {
        //checks value greater than 0
        //value is less than the owners balance
        if (_value > 0 && _value <= _balanceOf[msg.sender]) {
            //checks if the contract can receive token
            if (_to.isContract()) {
              ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
              _contract.tokenFallback(msg.sender, _value, _data);
            }
            //subtracts value of sent amount from owner sending
            _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
            //adds value of sent amount receiver
            _balanceOf[_to] = _balanceOf[_to].add(_value);

            return true;
        }
        return false;
    }
    //function/method of transfer from address from and to
    function transferFrom(address _from, address _to, uint _value)public returns (bool) {
        return transferFrom(_from, _to, _value, "");
    }
    //function/method of transfer from address to address
    function transferFrom(address _from, address _to, uint _value, bytes memory _data)public returns (bool) {
        //checks with owner allowance and balance
        if (_allowances[_from][msg.sender] > 0 && _value > 0 &&
            _allowances[_from][msg.sender] >= _value && _balanceOf[_from] >= _value) {
                _allowances[_from][msg.sender] -= _value;

              if (_to.isContract()) {
                ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
                _contract.tokenFallback(msg.sender, _value, _data);
              }
            //subs value - sender
            _balanceOf[_from] = _balanceOf[_from].sub(_value);
            //adds value - receiver
            _balanceOf[_to] = _balanceOf[_to].add(_value);
            //push event of transfer
            emit Transfer(_from, _to, _value);

            return true;
        }
        return false;
    }
    //function/method of approving transfer
    function approve(address _spender, uint _value)public returns (bool) {
        if (_balanceOf[msg.sender] >= _value) {
            _allowances[msg.sender][_spender] = _value;
          //push event for approval
          emit Approval(msg.sender, _spender, _value);
          return true;
        }
        return false;
    }
    //function/method of allowance
    //checks if allowancevalue at owner and spender is less than the balance
    function allowance(address _owner, address _spender)public view returns (uint) {
        if (_allowances[_owner][_spender] < _balanceOf[_owner]) {
          return _allowances[_owner][_spender];
        }
        return _balanceOf[_owner];
    }
}
