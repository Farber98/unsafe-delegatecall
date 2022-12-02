// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/VulnerableContract2.sol";
import "../src/MaliciousContract2.sol";

contract Reentrancy is Test {
    VulnerableContract2 vulnerable;
    MaliciousContract2 malicious;
    Lib2 lib;

    address payable vulnerableContractDeployer1 = payable(address(0x1));
    address payable maliciousContractDeployer2 = payable(address(0x2));

    function setUp() public {
        vm.startPrank(vulnerableContractDeployer1);
        lib = new Lib2();
        vm.stopPrank();

        vm.startPrank(vulnerableContractDeployer1);
        vulnerable = new VulnerableContract2(address(lib));
        vm.stopPrank();

        vm.startPrank(maliciousContractDeployer2);
        malicious = new MaliciousContract2(vulnerable);
        vm.stopPrank();
    }

    function testHijackVulnerableContract2() public {
        assertEq(vulnerable.owner(), vulnerableContractDeployer1);
        assertEq(vulnerable.lib(), address(lib));

        vm.startPrank(maliciousContractDeployer2);
        malicious.attack();
        vm.stopPrank();

        assertEq(vulnerable.owner(), address(malicious));
        assertEq(vulnerable.lib(), address(malicious));
    }
}
