pragma solidity ^0.4.23;

contract Sample {
    
    uint public thenum; 
    
    constructor(uint num) {
        thenum = num; 
    }
    
    function addNum(uint toadd) public {
        thenum = thenum + toadd; 
    }
}
