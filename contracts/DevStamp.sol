// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DevStamp {
    struct Stamp {
        uint256 timestamp;
        string reason;
    }

    mapping(address => Stamp[]) public builderStamps;

    event Stamped(address indexed builder, string reason);

    function stampBuilder(address builder, string memory reason) external {
        builderStamps[builder].push(Stamp(block.timestamp, reason));
        emit Stamped(builder, reason);
    }

    function getStamps(address builder) external view returns (Stamp[] memory) {
        return builderStamps[builder];
    }
}
