// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Foo {
    // slot 0
    uint256 public n = 0;
    // slot 1
    address public owner = msg.sender;
    bool public flag = true;
    uint16 public m = 1;
    // slot 2
    bytes32 private password; // the goal of the attacker is to retrieve this value, despite it being private

    // constants do not use storage
    uint256 public constant THREE = 3;

    // slot 3, 4, 5 (one for each array element)
    bytes32[3] public data;

    struct User {
        uint256 id;
        bytes32 password;
    }

    // slot 6 stores the length of the array
    // array elements are stored starting from slot hash(6)
    // slot where array element is stored = keccak256(slot)) + (index * elementSize)
    // where slot = 6 and elementSize = 2 (1 (uint) +  1 (bytes32))
    User[] private users;

    // slot 7:  empty
    // the entries for the mapping are stored at: hash(key, slot)
    // where slot = 7, key = map key
    mapping(uint256 => User) private idToUser;

    constructor(bytes32 _password) {
        password = _password;
    }

    function addUser(bytes32 _password) public {
        User memory user = User({ id: users.length, password: _password });

        users.push(user);
        idToUser[user.id] = user;
    }

    function getArrayLocation(
        uint256 slot,
        uint256 index,
        uint256 elementSize
    ) public pure returns (uint256) {
        return
            // array elements are stored starting from slot hash(slot)) + offset
            uint256(keccak256(abi.encodePacked(slot))) + (index * elementSize);
    }

    function getMapLocation(
        uint256 slot,
        uint256 key
    ) public pure returns (uint256) {
        // an entry of a mapping is stored at: hash(key, slot)
        return uint256(keccak256(abi.encodePacked(key, slot)));
    }
}
