// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IPauseV1} from "../interfaces/IPauseV1.sol";

abstract contract PauseBase is IPauseV1 {
    bool internal paused;

    modifier whenNotPaused() {
        require(!paused, "Paused!");
        _;
    }

    function isPaused() external view returns (bool) {
        return paused;
    }

    function pauseInternal() internal {
        paused = true;
        emit Paused(msg.sender);
    }

    function unpauseInternal() internal {
        paused = false;
        emit Unpaused(msg.sender);
    }
    uint256[49] private __gap;

}
