// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IPauseV1} from "./IPauseV1.sol";

interface IPauseV2 is IPauseV1 {
    function allowPauser(address _newPauser) external;
}