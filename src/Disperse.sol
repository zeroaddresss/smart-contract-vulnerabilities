// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

error Disperse__TransferFailed(address to, uint256 value);
error Disperse__TransferBalanceFailed();

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

contract Disperse {
    function disperseEther(
        address[] memory recipients,
        uint256[] memory values
    ) external payable {
        for (uint256 i = 0; i < recipients.length; i++) {
            (bool success, ) = recipients[i].call{ value: values[i] }("");
            require(
                success,
                Disperse__TransferFailed(recipients[i], values[i])
            );
        }

        uint256 balance = address(this).balance;
        if (balance > 0) {
            (bool sent, ) = msg.sender.call{ value: balance }("");
            require(sent, Disperse__TransferBalanceFailed());
        }
    }

    function disperseToken(
        IERC20 token,
        address[] memory recipients,
        uint256[] memory values
    ) external {
        uint256 total = 0;
        for (uint256 i = 0; i < recipients.length; i++) {
            total += values[i];
        }
        require(token.transferFrom(msg.sender, address(this), total));
        for (uint256 i = 0; i < recipients.length; i++)
            require(token.transfer(recipients[i], values[i]));
    }

    function disperseTokenSimple(
        IERC20 token,
        address[] memory recipients,
        uint256[] memory values
    ) external {
        for (uint256 i = 0; i < recipients.length; i++)
            require(token.transferFrom(msg.sender, recipients[i], values[i]));
    }
}
