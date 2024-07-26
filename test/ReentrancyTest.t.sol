// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Test, console } from "forge-std/Test.sol";
import { Victim, Attacker } from "../src/Reentrancy.sol";

contract ReentrancyTest is Test {
    Victim public victim;
    Attacker public attacker;

    function setUp() public {
        victim = new Victim();
        attacker = new Attacker(address(victim));
        vm.deal(address(victim), 100 ether);
        vm.deal(address(attacker), 1 ether);
    }

    function testAttackerCanDrainEther() public {
        setUp();

        console.log("[PRE-ATTACK] victim balance: ", victim.getBalance());
        console.log(
            "[PRE-ATTACK] attacker balance: ",
            address(attacker).balance
        );

        attacker.attack();

        console.log("[POST-ATTACK] victim balance: ", victim.getBalance());
        console.log(
            "[POST-ATTACK] attacker balance: ",
            address(attacker).balance
        );

        assertEq(victim.getBalance(), 0);
        assertEq(address(attacker).balance, 101 ether);
    }
}

/*
  forge test -vv

[⠑] Compiling...
No files changed, compilation skipped

Ran 1 test for test/ReentrancyTest.t.sol:ReentrancyTest
[PASS] testAttackerCanDrainEther() (gas: 1418743)
Logs:
  [PRE-ATTACK] victim balance:  100000000000000000000
  [PRE-ATTACK] attacker balance:  1000000000000000000
  [POST-ATTACK] victim balance:  0
  [POST-ATTACK] attacker balance:  101000000000000000000

Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 46.09ms (27.07ms CPU time)

Ran 1 test suite in 1.01s (46.09ms CPU time): 1 tests passed, 0 failed, 0 skipped (1 total tests)
*/
