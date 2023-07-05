// SPDX-License-Identifier: MIT
// Peter Robinson: Dec 2022 Solidity Recruitment Test
pragma solidity ^0.8.11;

import "./PauseBase.sol";

abstract contract PauseV1 is PauseBase {

    function pause() external override {
        pauseInternal();
    }

    function unpause() external override {
        unpauseInternal();
    }
    uint256[49] private __gap;
}