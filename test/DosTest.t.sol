// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { King, Exploit } from "../src/DoS.sol";
import { Test, console } from "forge-std/Test.sol";

contract DosTest is Test {
    King public king;
    Exploit public exploit;
    address public player;
    address public attacker;

    function setUp() public {
        king = new King();
        exploit = new Exploit();
        player = vm.addr(1);
        attacker = vm.addr(2);

        vm.deal(attacker, 2 ether);
        vm.deal(player, 4 ether);
    }

    function testAttackerCanCompromiseTheGame() public {
        // before the DoS, players can take part in the game as normal
        vm.prank(player);
        king.claimThrone{ value: 1 ether }();

        // the exploit contract is now the current king, but other users won't be able to play the game (because of the DoS)
        vm.prank(attacker);
        exploit.attack{ value: 2 ether }(king);

        // despite sending a higher ether value, the tx will fail and no player can claim the throne
        vm.prank(player);
        vm.expectRevert();
        king.claimThrone{ value: 3 ether }();

        assertEq(king.king(), address(exploit));
    }
}
