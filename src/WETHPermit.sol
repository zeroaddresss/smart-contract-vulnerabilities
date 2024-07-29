// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Unlike most ERC20 tokens, WETH does not have a `permit` function that needs approval from the spender
Indeed, calling the `permit` function on WETH contract triggers the fallback function, which defaults to the `deposit()` method

The attack unfolds as follows:
  1. The victim gives infinite approval for WETH spending
  2. The victim deposits a certain amount of WETH
  3. Attacker calls depositWithPermit, passes an empty signature and transfers all tokens from Alice into ERC20Bank, crediting the attacker for the deposit.
  4. Attacker withdraws all tokens credited to him.
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20Permit.sol";

contract Bank {
    IERC20Permit public immutable token;
    mapping(address => uint256) public balances;

    constructor(address _token) {
        token = IERC20Permit(_token);
    }

    function deposit(uint256 _amount) public payable {
        token.transferFrom(msg.sender, address(this), _amount);
        balances[msg.sender] += _amount;
    }

    function depositWithPermit(
        address owner,
        address recipient,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        token.permit(owner, recipient, amount, deadline, v, r, s);
        token.transferFrom(owner, address(this), amount);
        balances[recipient] += amount;
    }

    function withdraw(uint256 _amount) external {
        balances[msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);
    }
}
