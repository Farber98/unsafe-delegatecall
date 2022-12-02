// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/VulnerableContract.sol";
import "../src/MaliciousContract.sol";

contract Reentrancy is Test {
    VulnerableContract vulnerable;
    MaliciousContract malicious;
    Lib lib;

    address payable vulnerableContractDeployer1 = payable(address(0x1));
    address payable maliciousContractDeployer2 = payable(address(0x2));

    function setUp() public {
        vm.startPrank(vulnerableContractDeployer1);
        lib = new Lib();
        vm.stopPrank();

        vm.startPrank(vulnerableContractDeployer1);
        vulnerable = new VulnerableContract(lib);
        vm.stopPrank();

        vm.startPrank(maliciousContractDeployer2);
        malicious = new MaliciousContract(address(vulnerable));
        vm.stopPrank();
    }

    function testHijackVulnerableContract() public {
        assertEq(vulnerable.owner(), vulnerableContractDeployer1);
        vm.startPrank(maliciousContractDeployer2);
        malicious.attack();
        vm.stopPrank();
        assertEq(vulnerable.owner(), address(malicious));
    }
}
