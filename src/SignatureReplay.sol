// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MultiSigWallet {
    using ECDSA for bytes32;

    error SignatureReplay__InvalidSignature();
    error SignatureReplay__TransferFailed();

    address[2] public owners;

    constructor(address[2] memory _owners) payable {
        owners = _owners;
    }

    function deposit() external payable {}

    function transfer(
        address _to,
        uint256 _amount,
        bytes[2] memory _sigs
    ) external {
        bytes32 txHash = getTxHash(_to, _amount);
        require(_checkSigs(_sigs, txHash), SignatureReplay__InvalidSignature());

        (bool sent, ) = _to.call{ value: _amount }("");
        require(sent, SignatureReplay__TransferFailed());
    }

    function getTxHash(
        address _to,
        uint256 _amount
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount));
    }

    // this function does not check if the signature has already been used
    // hence the vulnerability to sig replay attacks
    function _checkSigs(
        bytes[2] memory _sigs,
        bytes32 _txHash
    ) private view returns (bool) {
        bytes32 ethSignedHash = MessageHashUtils.toEthSignedMessageHash(
            _txHash
        );

        for (uint256 i = 0; i < _sigs.length; i++) {
            address signer = ethSignedHash.recover(_sigs[i]);
            bool valid = signer == owners[i];

            if (!valid) {
                return false;
            }
        }

        return true;
    }
}
