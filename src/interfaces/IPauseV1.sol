// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IPauseV1 {
    event Paused(address account);
    event Unpaused(address account);

    function pause() external;
    function unpause() external;
    function isPaused() external view returns (bool);
}
