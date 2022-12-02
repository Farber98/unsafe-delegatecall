// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
    VulnerableContract is a contract that uses delegatecall to execute code.
    It is not obvious that the owner of VulnerableContract can be changed since there is no
    function inside VulnerableContract to do so. However an attacker can hijack the
    contract by exploiting delegatecall. 
*/

contract Lib {
    address public owner;

    function pwn() public {
        owner = msg.sender;
    }
}

contract VulnerableContract {
    address public owner;
    Lib public lib;

    constructor(Lib _lib) {
        owner = msg.sender;
        lib = Lib(_lib);
    }

    fallback() external payable {
        address(lib).delegatecall(msg.data);
    }
}
