// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { Test, console } from "forge-std/Test.sol";
import { Foo } from "../src/OnChainData.sol";

contract OnChainDataTest is Test {
    Foo foo;

    function setUp() public {
        foo = new Foo("myVerySecretPassword");
    }

    // https://ethereum.stackexchange.com/a/123950
    function toString(
        bytes32 source
    ) internal pure returns (string memory result) {
        uint8 length = 0;
        while (source[length] != 0 && length < 32) {
            length++;
        }
        assembly {
            result := mload(0x40)
            // new "memory end" including padding (the string isn't larger than 32 bytes)
            mstore(0x40, add(result, 0x40))
            // store length in memory
            mstore(result, length)
            // write actual data
            mstore(add(result, 0x20), source)
        }
    }

    function testAnyoneCanAccessStorageSlots() public {
        // load the slot 2 from storage (where we expect to find the password)
        bytes32 storedPassword = vm.load(address(foo), bytes32(uint256(2)));
        string memory password = toString(storedPassword);
        emit log_string(password);
        assertEq(password, "myVerySecretPassword");
    }
}

/*
Ran 1 test for test/OnChainDataTest.t.sol:OnChainDataTest                                                                                                                                       │
  20     │[PASS] testAnyoneCanAccessStorageSlots() (gas: 12012)                                                                                                                                           │
  21     │Logs:                                                                                                                                                                                           │
  22     │  myVerySecretPassword                                                                                                                                                                          │
  23     │                                                                                                                                                                                                │
  24 }   │Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 7.69ms (1.47ms CPU time)
*/
