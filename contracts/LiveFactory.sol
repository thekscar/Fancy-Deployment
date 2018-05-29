pragma solidity ^0.4.23; 

contract LiveFactory {
  function deployCode(bytes _code) returns (address deployedAddress) {
    
    assembly {
        deployedAddress := create(0, add(_code, 0x20), mload(_code))
        //jumpi(invalidJumpLabel, iszero(extcodesize(deployedAddress))) // jumps if no code at addresses
    }
    ContractDeployed(deployedAddress);
  }

  event ContractDeployed(address deployedAddress);
  
  function MergeBytes(bytes memory a, bytes memory b) public constant returns (bytes memory c) {
    // Store the length of the first array
    uint alen = a.length;
    // Store the length of BOTH arrays
    uint totallen = alen + b.length;
    // Count the loops required for array a (sets of 32 bytes)
    uint loopsa = (a.length + 31) / 32;
    // Count the loops required for array b (sets of 32 bytes)
    uint loopsb = (b.length + 31) / 32;
    assembly {
        let m := mload(0x40)
        // Load the length of both arrays to the head of the new bytes array
        mstore(m, totallen)
        // Add the contents of a to the array
        for {  let i := 0 } lt(i, loopsa) { i := add(1, i) } { mstore(add(m, mul(32, add(1, i))), mload(add(a, mul(32, add(1, i))))) }
        // Add the contents of b to the array
        for {  let i := 0 } lt(i, loopsb) { i := add(1, i) } { mstore(add(m, add(mul(32, add(1, i)), alen)), mload(add(b, mul(32, add(1, i))))) }
        mstore(0x40, add(m, add(32, totallen)))
        c := m
    }
}
}