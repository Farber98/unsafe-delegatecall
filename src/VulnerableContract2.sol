// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
This is a more sophisticated version of the previous exploit.

1. Alice deploys Lib2 and VulnerableContract2 with the address of Lib
2. Eve deploys Attack with the address of VulnerableContract2
3. Eve calls MaliciousContract2.attack()
4. Attack is now the owner of VulnerableContract2

What happened?
Notice that the state variables are not defined in the same manner in Lib2
and VulnerableContract2. This means that calling Lib2.doSomething() will change the first
state variable inside VulnerableContract2, which happens to be the address of lib2.

Inside attack(), the first call to doSomething() changes the address of lib2
store in VulnerableContract2. Address of lib is now set to Attack.
The second call to doSomething() calls MaliciousContract2.doSomething() and here we
change the owner.
*/

contract Lib2 {
    uint256 public someNumber;

    function doSomething(uint256 _num) public {
        someNumber = _num;
    }
}

contract VulnerableContract2 {
    address public lib;
    address public owner;
    uint256 public someNumber;

    constructor(address _lib) {
        lib = _lib;
        owner = msg.sender;
    }

    function doSomething(uint256 _num) public {
        lib.delegatecall(abi.encodeWithSignature("doSomething(uint256)", _num));
    }
}
