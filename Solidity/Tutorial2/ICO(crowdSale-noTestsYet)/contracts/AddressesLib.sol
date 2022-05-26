pragma solidity ^0.5.11;
//library - addresses - library to store address
library Addresses {

  function isContract(address _base) internal view returns (bool) {
     uint codeSize;
     //still working on solidity changes with update
     //aseembly is currently not being used
     //will update alternative
      assembly{
          codeSize := extcodesize(_base)
      }
      return codeSize > 0;
  }
}
